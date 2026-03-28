import { registerDecorator, ValidationOptions, ValidatorConstraint, ValidatorConstraintInterface, ValidationArguments } from 'class-validator';

@ValidatorConstraint({ name: 'isEcuadorianId', async: false })
export class IsEcuadorianIdConstraint implements ValidatorConstraintInterface {
  validate(value: any, args: ValidationArguments) {
    if (typeof value !== 'string') return false;
    const id = value.trim();

    if (id.length === 10) {
      return this.validateCedula(id);
    } else if (id.length === 13) {
      return this.validateRuc(id);
    }
    return false;
  }

  private validateCedula(cedula: string): boolean {
    if (!/^\d+$/.test(cedula)) return false;

    const coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    let suma = 0;

    for (let i = 0; i < 9; i++) {
      let digito = parseInt(cedula[i]);
      let producto = digito * coeficientes[i];
      if (producto > 9) {
        producto = Math.floor(producto / 10) + (producto % 10);
      }
      suma += producto;
    }

    const residuo = suma % 10;
    const digitoVerificador = residuo === 0 ? 0 : 10 - residuo;
    const ultimoDigito = parseInt(cedula[9]);

    return digitoVerificador === ultimoDigito;
  }

  private validateRuc(ruc: string): boolean {
    if (!/^\d+$/.test(ruc)) return false;

    const tercerDigito = parseInt(ruc[2]);
    if (tercerDigito !== 6 && tercerDigito !== 9) return false;

    if (!ruc.endsWith('001')) return false;

    // Optional: Could also validate the first 10 digits as a base
    return true;
  }

  defaultMessage(args: ValidationArguments) {
    return 'El documento (Cédula/RUC) no es válido o no cumple el formato ecuatoriano';
  }
}

export function IsEcuadorianId(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsEcuadorianIdConstraint,
    });
  };
}
