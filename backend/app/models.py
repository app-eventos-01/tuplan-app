from sqlalchemy import Boolean, Column, DateTime, Integer, String, Text
from sqlalchemy.sql import func

from .database import Base


class Evento(Base):
    __tablename__ = "eventos"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(200), nullable=False)
    descripcion = Column(Text, nullable=False)
    fecha_inicio = Column(DateTime(timezone=True), nullable=False)
    fecha_fin = Column(DateTime(timezone=True), nullable=True)
    ubicacion = Column(String(200), nullable=False)
    categoria = Column(String(120), nullable=False)
    precio = Column(String(80), nullable=False)
    destacado = Column(Boolean, default=False, nullable=False)
    empresa_id = Column(Integer, nullable=False, index=True)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())
