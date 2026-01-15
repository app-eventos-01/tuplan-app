from dataclasses import dataclass
from typing import Optional

from fastapi import Header, HTTPException, status


ALLOWED_ROLES = {"admin", "empresa", "lector"}


@dataclass(frozen=True)
class Actor:
    rol: str
    empresa_id: Optional[int]


def get_actor(
    x_role: str = Header(default="lector"),
    x_empresa_id: Optional[int] = Header(default=None),
) -> Actor:
    rol = x_role.lower()
    if rol not in ALLOWED_ROLES:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Rol no permitido.",
        )
    return Actor(rol=rol, empresa_id=x_empresa_id)


def ensure_can_write(actor: Actor, empresa_id: int) -> None:
    if actor.rol not in ALLOWED_ROLES:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Rol no permitido.",
        )
    if actor.rol == "lector":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para escribir.",
        )
    if actor.rol == "empresa" and actor.empresa_id != empresa_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No puedes modificar eventos de otra empresa.",
        )


def ensure_can_read(actor: Actor, empresa_id: int) -> None:
    if actor.rol not in ALLOWED_ROLES:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Rol no permitido.",
        )
    if actor.rol == "empresa" and actor.empresa_id != empresa_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No puedes ver eventos de otra empresa.",
        )
