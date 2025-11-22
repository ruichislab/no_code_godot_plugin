# 🎮 RuichisLab Framework - Edición Profesional Godot 4

### *La herramienta definitiva No-Code para Godot Engine 4.x*

<div align="center">

**Versión:** 5.0 Pro | **Autor:** Ruichis Lab | **Licencia:** MIT

*Crea juegos profesionales sin escribir una sola línea de código, ahora con herramientas visuales avanzadas.*

</div>

---

## 🚀 Novedades Versión Pro

- **Organización Total:** Todos los nodos agrupados bajo `RuichisLab/` en el editor.
- **Visualización:** Gizmos personalizados para ver rutas de patrulla, áreas de daño y triggers directamente en el viewport.
- **Sistemas Avanzados:**
    - 🧠 **IA Behavior Trees:** Inteligencia artificial compleja sin código.
    - 📜 **Sistema de Misiones:** Gestión completa de quests con guardado.
    - 💬 **Diálogos Visual Novel:** Conversaciones con retratos y efectos.
    - 🎒 **Inventario & Cartas:** Sistemas drag & drop nativos.
    - ⚙️ **Settings:** Menús de opciones (Audio/Video/Input) autogestionados.
- **Game Feel:** Cámara con *Screen Shake*, *Lookahead* y *Hit Stop*.

---

## 🛠️ Asistente de Creación

¡Empieza en segundos!
1. Ve a **Proyecto > Herramientas > RuichisLab: Crear Escena Básica**.
2. El plugin generará automáticamente una escena con:
   - Nivel base.
   - Jugador con físicas configuradas (`RL_PlatformerController`).
   - Capa de UI lista para usar.

---

## 📦 Componentes Principales (Prefijo `RL_`)

### 🧠 Lógica y Control
| Componente | Descripción |
|------------|-------------|
| **RL_Trigger** | Ejecuta acciones al entrar en un área (Verde en editor). |
| **RL_StateMachine** | Máquina de estados finitos para personajes. |
| **RL_BehaviorTree** | Árbol de comportamiento para IA avanzada. |
| **RL_InputListener** | Detecta teclas y ejecuta acciones. |

### ⚔️ Combate y RPG
| Componente | Descripción |
|------------|-------------|
| **RL_Stats** | Salud, Mana, Fuerza. Gestiona atributos y modificadores. |
| **RL_Hurtbox / Hitbox** | Sistema de daño profesional. |
| **RL_Projectile** | Proyectiles con rebote, perforación y seguimiento (homing). |
| **RL_EquipmentSlot** | Slots de equipo que modifican stats automáticamente. |

### 🌍 Mundo y Ambiente
| Componente | Descripción |
|------------|-------------|
| **RL_DayNightCycle** | Ciclo día/noche con gradientes de color. |
| **RL_Weather** | Clima (Lluvia, Nieve) optimizado con partículas. |
| **RL_Teleporter** | Teletransporte visual con líneas de conexión. |
| **RL_LevelPortal** | Cambio de escenas con carga asíncrona y transiciones. |

### 🎴 Cartas e Inventario
| Componente | Descripción |
|------------|-------------|
| **RL_Card** | Carta interactiva con Drag & Drop. |
| **RL_Hand / Deck** | Gestión de mano y mazo. |
| **RL_InventoryGrid** | Visualizador automático del inventario global. |

---

## 🔧 Configuración (Settings)

El plugin incluye un sistema de configuración persistente en `user://settings.cfg`.
- Usa **RL_VolumeSlider** para controlar audio.
- Usa **RL_InputRemapButton** para remapear teclas.
Todo se guarda automáticamente.

---

## 📝 Convenciones

- **Nodos:** Empiezan con `RL_` (ej: `RL_Trigger`).
- **Recursos:** Empiezan con `RL_Recurso` (ej: `RL_RecursoMision`).
- **Idioma:** Todo está en **Español**.

---

<div align="center">
Hecho con ❤️ para la comunidad de Godot.
</div>
