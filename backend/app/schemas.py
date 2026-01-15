from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict


class EventoBase(BaseModel):
    titulo: str
    descripcion: str
    fecha_inicio: datetime
    fecha_fin: Optional[datetime] = None
    ubicacion: str
    categoria: str
    precio: str
    destacado: bool = False
    empresa_id: int


class EventoCreate(EventoBase):
    pass


class EventoUpdate(BaseModel):
    titulo: Optional[str] = None
    descripcion: Optional[str] = None
    fecha_inicio: Optional[datetime] = None
    fecha_fin: Optional[datetime] = None
    ubicacion: Optional[str] = None
    categoria: Optional[str] = None
    precio: Optional[str] = None
    destacado: Optional[bool] = None
    empresa_id: Optional[int] = None


class Evento(EventoBase):
    id: int
    creado_en: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)
