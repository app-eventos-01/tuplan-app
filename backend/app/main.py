from datetime import datetime
from typing import List

from fastapi import Depends, FastAPI, Form, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, RedirectResponse
from sqlalchemy.orm import Session

from .database import Base, engine, get_db
from .models import Evento
from .permissions import Actor, ensure_can_read, ensure_can_write, get_actor
from .schemas import Evento as EventoSchema
from .schemas import EventoCreate, EventoUpdate

app = FastAPI(title="TuPlan API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    Base.metadata.create_all(bind=engine)


@app.get("/eventos", response_model=List[EventoSchema])
def listar_eventos(
    actor: Actor = Depends(get_actor),
    db: Session = Depends(get_db),
) -> List[Evento]:
    query = db.query(Evento)
    if actor.rol == "empresa":
        if actor.empresa_id is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Se requiere X-Empresa-Id para este rol.",
            )
        query = query.filter(Evento.empresa_id == actor.empresa_id)
    return query.order_by(Evento.fecha_inicio.asc()).all()


@app.get("/eventos/{evento_id}", response_model=EventoSchema)
def obtener_evento(
    evento_id: int,
    actor: Actor = Depends(get_actor),
    db: Session = Depends(get_db),
) -> Evento:
    evento = db.get(Evento, evento_id)
    if evento is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No existe.")
    ensure_can_read(actor, evento.empresa_id)
    return evento


@app.post("/eventos", response_model=EventoSchema, status_code=status.HTTP_201_CREATED)
def crear_evento(
    payload: EventoCreate,
    actor: Actor = Depends(get_actor),
    db: Session = Depends(get_db),
) -> Evento:
    ensure_can_write(actor, payload.empresa_id)
    evento = Evento(**payload.model_dump())
    db.add(evento)
    db.commit()
    db.refresh(evento)
    return evento


@app.put("/eventos/{evento_id}", response_model=EventoSchema)
def actualizar_evento(
    evento_id: int,
    payload: EventoUpdate,
    actor: Actor = Depends(get_actor),
    db: Session = Depends(get_db),
) -> Evento:
    evento = db.get(Evento, evento_id)
    if evento is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No existe.")
    ensure_can_write(actor, evento.empresa_id)

    update_data = payload.model_dump(exclude_unset=True)
    if "empresa_id" in update_data:
        ensure_can_write(actor, update_data["empresa_id"])

    for field, value in update_data.items():
        setattr(evento, field, value)

    db.commit()
    db.refresh(evento)
    return evento


@app.delete("/eventos/{evento_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_evento(
    evento_id: int,
    actor: Actor = Depends(get_actor),
    db: Session = Depends(get_db),
) -> None:
    evento = db.get(Evento, evento_id)
    if evento is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No existe.")
    ensure_can_write(actor, evento.empresa_id)
    db.delete(evento)
    db.commit()


@app.get("/panel", response_class=HTMLResponse)
def panel_eventos() -> str:
    return """
    <!doctype html>
    <html lang="es">
      <head>
        <meta charset="utf-8" />
        <title>Panel TuPlan</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 32px; }
          form { max-width: 520px; display: grid; gap: 12px; }
          label { font-weight: 600; }
          input, textarea { padding: 8px; width: 100%; }
          button { padding: 10px 16px; }
        </style>
      </head>
      <body>
        <h1>Panel de eventos</h1>
        <p>Usa este formulario para insertar eventos por empresa.</p>
        <form method="post" action="/panel">
          <label>Empresa ID</label>
          <input name="empresa_id" type="number" required />
          <label>Rol</label>
          <input name="rol" type="text" value="empresa" />
          <label>Título</label>
          <input name="titulo" required />
          <label>Descripción</label>
          <textarea name="descripcion" rows="3" required></textarea>
          <label>Fecha inicio (ISO 8601)</label>
          <input name="fecha_inicio" placeholder="2025-01-05T20:00:00" required />
          <label>Fecha fin (ISO 8601)</label>
          <input name="fecha_fin" placeholder="2025-01-05T22:00:00" />
          <label>Ubicación</label>
          <input name="ubicacion" required />
          <label>Categoría</label>
          <input name="categoria" required />
          <label>Precio</label>
          <input name="precio" required />
          <label>Destacado</label>
          <input name="destacado" type="checkbox" />
          <button type="submit">Crear evento</button>
        </form>
      </body>
    </html>
    """


@app.post("/panel")
def panel_crear_evento(
    empresa_id: int = Form(...),
    rol: str = Form("empresa"),
    titulo: str = Form(...),
    descripcion: str = Form(...),
    fecha_inicio: str = Form(...),
    fecha_fin: str | None = Form(None),
    ubicacion: str = Form(...),
    categoria: str = Form(...),
    precio: str = Form(...),
    destacado: bool = Form(False),
    db: Session = Depends(get_db),
) -> RedirectResponse:
    actor = Actor(rol=rol.lower(), empresa_id=empresa_id)
    ensure_can_write(actor, empresa_id)

    evento = Evento(
        titulo=titulo,
        descripcion=descripcion,
        fecha_inicio=datetime.fromisoformat(fecha_inicio),
        fecha_fin=datetime.fromisoformat(fecha_fin) if fecha_fin else None,
        ubicacion=ubicacion,
        categoria=categoria,
        precio=precio,
        destacado=destacado,
        empresa_id=empresa_id,
    )
    db.add(evento)
    db.commit()
    return RedirectResponse(url="/panel", status_code=status.HTTP_303_SEE_OTHER)
