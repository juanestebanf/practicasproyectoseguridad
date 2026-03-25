import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AlertsService } from './alerts.service';
import { AlertsController } from './alerts.controller';
import { Alert, Evidence, AlertEvent } from './entities/alert.entity';

import { AlertsGateway } from './alerts.gateway';

@Module({
  imports: [TypeOrmModule.forFeature([Alert, Evidence, AlertEvent])],
  controllers: [AlertsController],
  providers: [AlertsService, AlertsGateway],
  exports: [AlertsService, AlertsGateway],
})
export class AlertsModule {}
