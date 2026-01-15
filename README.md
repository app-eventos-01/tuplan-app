# TuPlan (Flutter + FastAPI)

Este repositorio contiene:

- **App Flutter** (`/lib`) que consume eventos vía HTTP.
- **Backend FastAPI** (`/backend`) conectado a PostgreSQL.
- **Panel web simple** en `/panel` para insertar eventos manualmente.

## Backend (FastAPI + PostgreSQL)

1. Instala dependencias:

```
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. Configura la base de datos con la variable:

```
export DATABASE_URL="postgresql+psycopg://tuplan:tuplan@localhost:5432/tuplan"
```

3. Arranca el servidor:

```
uvicorn app.main:app --reload
```

### Endpoints principales

- `GET /eventos`
- `GET /eventos/{id}`
- `POST /eventos`
- `PUT /eventos/{id}`
- `DELETE /eventos/{id}`

### Panel web

Visita `http://localhost:8000/panel` para crear eventos manualmente.

## Flutter (consumo HTTP)

El cliente obtiene eventos desde `lib/data/events_api.dart` con `kApiBaseUrl`.

Ejemplos de base URL:

- Emulador Android: `http://10.0.2.2:8000`
- iOS simulator / web local: `http://localhost:8000`

## Permisos

Las reglas de permisos por rol y empresa están documentadas en
`backend/README_PERMISOS.md`.
