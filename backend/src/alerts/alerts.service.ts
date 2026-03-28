import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Alert, AlertStatus, Evidence } from './entities/alert.entity';
import { User, UserRole } from '../users/entities/user.entity';
import { AlertsGateway } from './alerts.gateway';

@Injectable()
export class AlertsService {
  constructor(
    @InjectRepository(Alert)
    private alertsRepository: Repository<Alert>,
    @InjectRepository(Evidence)
    private evidenceRepository: Repository<Evidence>,
    private alertsGateway: AlertsGateway,
  ) {}

  async create(createAlertDto: any, user: any): Promise<Alert> {
    const alert = this.alertsRepository.create({
      titulo: createAlertDto.titulo,
      descripcion: createAlertDto.descripcion,
      prioridad: createAlertDto.prioridad,
      ubicacion: createAlertDto.ubicacion,
      lat: createAlertDto.lat,
      lng: createAlertDto.lng,
      ciudadano_id: user.userId,
    });

    // AUTO-ASIGNACIÓN POR PROXIMIDAD
    const nearestOperator = await this.findNearestOperator(createAlertDto.lat, createAlertDto.lng);
    if (nearestOperator) {
      alert.operador_id = nearestOperator.id;
      alert.estado = AlertStatus.EN_PROGRESO;
    }

    const savedAlert = await this.alertsRepository.save(alert);
    
    // EMITIR EN TIEMPO REAL
    this.alertsGateway.emitNewAlert(savedAlert);
    
    return savedAlert;
  }

  private async findNearestOperator(lat: number, lng: number): Promise<any | null> {
    // Buscamos operadores activos que tengan ubicación
    // Nota: Necesitamos acceder al repositorio de usuarios
    // Para simplificar esta demo, usaremos una consulta directa si fuera posible, 
    // pero como estamos en NestJS inyectaremos el repositorio si es necesario.
    // De momento, mockearemos la búsqueda o usaremos QueryBuilder si está disponible.
    
    const operators = await this.alertsRepository.manager.find(User, {
      where: { rol: UserRole.OPERADOR, active: true }
    }) as any[];

    if (!operators || operators.length === 0) return null;

    let nearest = null;
    let minDistance = Infinity;

    for (const op of operators) {
      if (op.lat && op.lng) {
        const dist = this.calculateDistance(lat, lng, op.lat, op.lng);
        if (dist < minDistance) {
          minDistance = dist;
          nearest = op;
        }
      }
    }

    return nearest;
  }

  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371; // Radio de la tierra en km
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = 
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  async findOne(id: string): Promise<Alert> {
    const alert = await this.alertsRepository.findOne({
      where: { id },
      relations: ['ciudadano', 'operador', 'autoridad', 'evidencias', 'historial'],
    });
    if (!alert) throw new NotFoundException('Alerta no encontrada');
    return alert;
  }

  async acceptAlert(alertId: string, operatorId: string): Promise<Alert> {
    await this.alertsRepository.update(alertId, {
      operador_id: operatorId,
      estado: AlertStatus.EN_PROGRESO,
    });
    return this.findOne(alertId);
  }

  async findAllActive(): Promise<Alert[]> {
    return this.alertsRepository.find({
      where: [{ estado: AlertStatus.PENDIENTE }, { estado: AlertStatus.EN_PROGRESO }],
      relations: ['ciudadano', 'operador'],
    });
  }

  async findFinalized(): Promise<Alert[]> {
    return this.alertsRepository.find({
      where: { estado: AlertStatus.FINALIZADA },
      relations: ['ciudadano', 'operador'],
      order: { fecha: 'DESC' },
    });
  }

  async findByUser(userId: string): Promise<Alert[]> {
    return this.alertsRepository.find({
      where: { ciudadano: { id: userId } },
      order: { fecha: 'DESC' },
    });
  }

  async findByOperator(operatorId: string): Promise<Alert[]> {
    return this.alertsRepository.find({
      where: { operador_id: operatorId },
      relations: ['ciudadano'],
    });
  }

  async findPendingApproval(): Promise<Alert[]> {
    return this.alertsRepository.find({
      where: { estado: AlertStatus.ESPERANDO_APROBACION },
      relations: ['operador', 'autoridad'],
    });
  }

  async assignOperator(alertId: string, operatorId: string): Promise<Alert> {
    await this.alertsRepository.update(alertId, {
      operador_id: operatorId,
      estado: AlertStatus.EN_PROGRESO,
    });
    return this.findOne(alertId);
  }

  async uploadReport(alertId: string, filePath: string): Promise<Alert> {
    const alert = await this.alertsRepository.findOne({ where: { id: alertId } });
    if (!alert) throw new NotFoundException('Alerta no encontrada');
    alert.reporte_file_path = filePath;
    alert.estado = AlertStatus.ESPERANDO_APROBACION;
    return this.alertsRepository.save(alert);
  }

  async finalizeWithReport(alertId: string, report: string): Promise<Alert> {
    await this.alertsRepository.update(alertId, {
      reporte_texto: report,
      estado: AlertStatus.ESPERANDO_APROBACION,
    });
    return this.findOne(alertId);
  }

  async approveReport(alertId: string): Promise<Alert> {
    const alert = await this.alertsRepository.findOne({ where: { id: alertId } });
    if (!alert) throw new NotFoundException('Alerta no encontrada');
    alert.estado = AlertStatus.FINALIZADA;
    return this.alertsRepository.save(alert);
  }

  async rejectReport(alertId: string, feedback: string): Promise<Alert> {
    const alert = await this.alertsRepository.findOne({ where: { id: alertId } });
    if (!alert) throw new NotFoundException('Alerta no encontrada');
    alert.admin_feedback = feedback;
    alert.estado = AlertStatus.RECHAZADA;
    return this.alertsRepository.save(alert);
  }

  async assignAuthority(alertId: string, authorityId: string): Promise<Alert> {
    await this.alertsRepository.update(alertId, {
      autoridad_id: authorityId,
      estado: AlertStatus.AUTORIDAD_ASIGNADA,
    });
    return this.findOne(alertId);
  }

  async uploadEvidence(alertId: string, filePath: string, fileType: string): Promise<Evidence> {
    const alert = await this.alertsRepository.findOne({ where: { id: alertId } });
    if (!alert) throw new NotFoundException('Alerta no encontrada');
    
    const evidence = this.evidenceRepository.create({
      file_path: filePath,
      file_type: fileType,
      alert: alert,
    });
    return this.evidenceRepository.save(evidence);
  }

  async getSummary(): Promise<any> {
    const activeAlerts = await this.alertsRepository.count({
      where: { estado: AlertStatus.PENDIENTE }
    });
    const attendedToday = await this.alertsRepository.count({
      where: { estado: AlertStatus.FINALIZADA }
    });

    const activeOperators = await this.alertsRepository.manager.count(User, {
      where: { rol: UserRole.OPERADOR, active: true }
    });

    return {
      activeAlerts,
      attendedToday,
      activeOperators,
    };
  }

  async getOperatorStats(operatorId: string): Promise<any> {
    const totalAssigned = await this.alertsRepository.count({
      where: { operador_id: operatorId }
    });
    const finalized = await this.alertsRepository.count({
      where: { operador_id: operatorId, estado: AlertStatus.FINALIZADA }
    });

    // Eficiencia simple: % de alertas finalizadas sobre total asignadas
    const eficiencia = totalAssigned > 0 ? (finalized / totalAssigned) * 100 : 0;

    return {
      alertasAtendidasHoy: finalized,
      eficiencia: Math.round(eficiencia * 10) / 10,
      tiempoPromedioRespuesta: finalized > 0 ? "8 min" : "N/A", // Mock del tiempo por ahora
    };
  }
}
