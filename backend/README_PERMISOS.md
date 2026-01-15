# Permisos y roles (TuPlan API)

El backend expone reglas simples de permisos usando encabezados HTTP para
controlar acceso por empresa y por rol.

## Roles disponibles

- **admin**: acceso total a todos los eventos.
- **empresa**: acceso solo a eventos cuya `empresa_id` coincide con el encabezado.
- **lector**: solo lectura, sin permisos de escritura.

## Encabezados requeridos

| Encabezado | Descripción |
| --- | --- |
| `X-Role` | Rol del usuario (`admin`, `empresa` o `lector`). |
| `X-Empresa-Id` | ID numérico de la empresa (obligatorio para rol `empresa`). |

## Ejemplos

### Listar eventos como empresa

```
GET /eventos
X-Role: empresa
X-Empresa-Id: 42
```

### Crear evento como empresa

```
POST /eventos
X-Role: empresa
X-Empresa-Id: 42
Content-Type: application/json

{
  "titulo": "Concierto acústico",
  "descripcion": "Show íntimo con artistas locales.",
  "fecha_inicio": "2025-01-05T20:00:00",
  "fecha_fin": "2025-01-05T22:00:00",
  "ubicacion": "Zona Sur, La Paz",
  "categoria": "Música",
  "precio": "Bs 40",
  "destacado": true,
  "empresa_id": 42
}
```

### Lectores (solo lectura)

```
GET /eventos
X-Role: lector
```

Si un rol intenta operar sobre una empresa distinta, el API devuelve **403**.
