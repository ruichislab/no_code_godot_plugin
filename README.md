# 🎮 RuichisLab Framework
### *Framework Profesional de Desarrollo de Videojuegos Sin Código para Godot 4.x*

<div align="center">

**Versión:** 4.0 | **Autor:** Ruichis Lab | **Licencia:** MIT

[![Godot Engine](https://img.shields.io/badge/Godot-4.x-478CBF?style=flat&logo=godot-engine&logoColor=white)](https://godotengine.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Made with GDScript](https://img.shields.io/badge/Made%20with-GDScript-blue.svg)](https://godotengine.org/)

*Crea juegos profesionales sin escribir una sola línea de código*

[Características](#-características) • [Inicio Rápido](#-inicio-rápido) • [Tutoriales](#-tutoriales-paso-a-paso) • [Componentes](#-biblioteca-de-componentes) • [Ejemplos](#-ejemplos-prácticos)

</div>

---

## 📖 ¿Qué es RuichisLab?

**RuichisLab** es un framework completo de desarrollo de videojuegos que transforma Godot Engine en una herramienta accesible pero potente. Hemos encapsulado lógica compleja (máquinas de estados, inventarios, IA, combate, guardado) en componentes visuales de **arrastrar y soltar**.

### 🎯 ¿Qué Puedes Crear?

| Género | Características Incluidas |
|--------|--------------------------|
| 🏰 **RPGs** | Misiones, Diálogos, Tiendas, Inventario, Niveles |
| 🏃 **Plataformas** | Físicas precisas, Coyote Time, Jump Buffer |
| ⚔️ **Acción** | Combate, Esquivas, Enemigos, Jefes |
| 🏎️ **Carreras** | Físicas arcade, Gestión de vueltas |
| 🧩 **Puzzles** | Movimiento en grid, Objetos empujables |
| 🎴 **Cartas** | Construcción de mazos, Gestión de mano |
| 🏭 **Tycoon/Idle** | Generación de recursos, Construcción |
| ♟️ **Estrategia** | Combate por turnos, Selección de unidades |

---

## ✨ Características

- 🎨 **79+ Componentes Listos** - Organizados por categoría
- 📦 **Cero Código Requerido** - Solo configuración visual
- 🔧 **Totalmente Extensible** - Añade tus propios componentes
- 💾 **Sistema de Guardado Completo** - Auto-guardado y slots múltiples
- 🎮 **Multi-Plataforma** - PC, Móvil, Web
- 📱 **Controles Móviles** - Joystick virtual incluido
- 🌍 **Listo para Localización** - Soporte multi-idioma
- 🎵 **Gestión de Audio** - Sistemas de música y SFX
- 📊 **Basado en Datos** - Configuración mediante recursos
- 🚀 **Optimizado** - Object pooling y sistemas eficientes

---

## 🚀 Inicio Rápido

### Instalación

1. **Descarga** la carpeta `addons/no_code_godot_plugin`
2. **Cópiala** a `res://addons/` de tu proyecto
3. Ve a **Proyecto > Configuración del Proyecto > Plugins**
4. **Activa** "No-code-Godot-Plugin"
5. **Recarga** el proyecto (Proyecto > Recargar Proyecto Actual)
6. ¡Listo! Busca nodos bajo la categoría **`RuichisLab/`**

# 🎮 RuichisLab — Guía Completa

**RuichisLab** es un conjunto de componentes y utilidades para Godot diseñado para acelerar la creación de juegos sin necesidad de programar. Esta guía sustituye y amplía el README original con tutoriales, buenas prácticas, ejemplos y referencia rápida de los componentes incluidos.

**Estado:** Estable para Godot 4.x (puede funcionar en 3.x con adaptaciones).  
**Licencia:** MIT.  
**Carpeta del plugin:** `addons/no_code_godot_plugin`

--

**Qué encontrarás en esta guía**
- **Instalación y activación** del plugin
- **Flujo de trabajo**: cómo estructurar escenas y proyectos
- **Tutoriales paso a paso** para géneros comunes (RPG, plataformas, tycoon, cartas)
- **Referencia rápida** de componentes más usados y ejemplos de configuración
- **Sistema de guardado, autoloads y configuración**
- **Crear acciones y extender el sistema** (pequeños snippets)
- **Rendimiento, despliegue y resolución de problemas**

--

**Instalación rápida**

1. Copia la carpeta del plugin a tu proyecto Godot:

```bash
cp -r path/to/no_code_godot_plugin /ruta/a/tu/proyecto/res://addons/no_code_godot_plugin
```

2. En Godot: `Proyecto > Configuración del Proyecto > Plugins` y activa `No-code-Godot-Plugin`.
3. Si el plugin registra autoloads automáticamente y no aparecen, añade los singletons manualmente en `Proyecto > Proyecto Settings > AutoLoad` usando las rutas en `addons/no_code_godot_plugin/Autoloads/`.

Nota: Si Godot te lanza errores del tipo "Too few arguments for add_custom_type()" o similares, actualiza a la versión estable recomendada (Godot 4.x) o asegúrate de que `no_code_plugin.gd` contiene el wrapper `add_custom_type_safe` (ya incluido en este plugin).

--

**Estructura de un proyecto recomendado**

Organiza tu proyecto así para mantenerlo escalable:

```
res://
├── addons/no_code_godot_plugin/
├── scenes/
│   ├── player/
│   ├── ui/
│   └── levels/
├── scripts/ (si añades scripts propios)
└── resources/
```

--

**Autoloads (singletons)**

El plugin usa varios autoloads (gestores). Si no se añadieron automáticamente, añádelos manualmente:

- `GameManager` -> `res://addons/no_code_godot_plugin/Autoloads/GameManager.gd`
- `AudioManager` -> `res://addons/no_code_godot_plugin/Autoloads/AudioManager.gd`
- `SaveManager` -> `res://addons/no_code_godot_plugin/Autoloads/SaveManager.gd`
- `PoolManager` -> `res://addons/no_code_godot_plugin/Autoloads/PoolManager.gd`

En `Project Settings > AutoLoad` haz clic en `Path`, selecciona el `.gd` y asigna el nombre.

--

**Tutorial rápido: tu primer personaje (Top‑Down RPG)**

1. Crea una nueva escena con `CharacterBody2D` como raíz y nómbrala `Player`.
2. Añade un `AnimatedSprite2D` y configura `SpriteFrames` (idle, walk, attack).
3. Añade `CollisionShape2D` con la forma adecuada.
4. Añade el componente `RuichisLab/TopDownController` como hijo del `Player`.
	- En el Inspector: `Velocidad Máxima: 300`, `Animar Sprite: ON`, `Nodo Sprite: ./AnimatedSprite2D`.
5. Añade `RuichisLab/Hurtbox` y configura `Estadisticas` si lo deseas.
6. Añade `RuichisLab/MeleeWeapon` para ataques cuerpo a cuerpo y configura `Accion Ataque` (Input Map: `attack`).

Prueba la escena (F6) o ejecuta el proyecto (F5).

--

**Tutorial avanzado: crear un enemigo con patrulla y persecución**

1. Crea `Enemy.tscn` con `CharacterBody2D`.
2. Añade `RuichisLab/Patrol` y crea `Marker2D` como waypoints.
3. Añade `RuichisLab/Follower` con `Distancia Activacion: 200`.
4. Añade `Estadisticas` con `Salud Maxima: 50` y `RuichisLab/Hurtbox`.

El enemigo patrullará y perseguirá al jugador cuando éste entre en rango.

--

**Componentes clave y ejemplos de uso**

Usa los componentes arrastrándolos como nodos hijos o añadidos desde el menú (categoría `RuichisLab/`). A continuación un resumen (no exhaustivo):

- **TopDownController**: movimiento 8 direcciones.
   - Propiedades: `velocidad_max`, `aceleracion`, `animar_sprite`, `nodo_sprite`.
- **PlatformerController**: plataformas con coyote time/jump buffer.
- **Hurtbox / Hitbox**: recibir o causar daño; conecta `Estadisticas` para aplicar daño.
- **MeleeWeapon**: define `Hitbox`, `tiempo_ataque`, `cooldown` y `animacion_ataque`.
- **Patrol / Follower / MaquinaEstados / BehaviorTree**: IA básica a avanzada.
- **SaveManager**: maneja guardar/cargar; guarda en `user://` por defecto.

Ejemplo: configurar `MeleeWeapon` desde Inspector:

```
Accion Ataque: "attack" (InputMap)
Hitbox: ./HitboxArea
Tiempo Ataque: 0.25
Cooldown: 0.5
Animacion Ataque: "attack"
```

--

**Crear acciones personalizadas (GameAction)**

Para extender el sistema (por ejemplo, una acción curativa): crea un script con `class_name` que extienda de `GameAction`.

```gdscript
# AccionCurar.gd
extends GameAction
class_name AccionCurar

@export var cantidad: int = 10

func ejecutar(actor: Node):
	  var stats = actor.get_node_or_null("Estadisticas")
	  if stats:
			stats.curar(cantidad)
```

Una vez creado, `AccionCurar` aparecerá en los selectores de acciones del editor.

--

**Sistema de Guardado**

El plugin incluye `SaveManager` en `addons/no_code_godot_plugin/Autoloads/SaveManager.gd`.

- Ubicación por defecto: `user://saves/`
- Formato: JSON (usa `to_json` / `parse_json` internamente para compatibilidad entre versiones).

Si necesitas borrar una partida manualmente desde scripts, usa:

```gdscript
var ruta = "user://saves/save_01.json"
if FileAccess.file_exists(ruta):
	  FileAccess.remove(ruta)
```

--

**Depuración y problemas comunes**

- "Too few arguments for add_custom_type()": asegúrate de que `no_code_plugin.gd` contiene `add_custom_type_safe` o actualiza a Godot 4.x.
- Errores de JSON entre versiones: usa `to_json()` y `parse_json()` (Godot 4) en lugar de `JSON.stringify`/`JSON.parse`.
- Errores al manipular autoloads en tiempo de editor: añade los singletons manualmente desde `Project > Project Settings > AutoLoad`.

Si el plugin no carga, revisa la consola de Godot y copia los mensajes completos aquí para que podamos diagnosticar.

--

**Optimización y buenas prácticas**

- Reutiliza nodos con `PoolManager` y evita instanciar/destruir masivamente en runtime.
- Mantén texturas atlased siempre que sea posible para reducir draw calls.
- Usa `yield` / `await` con moderación y favorece señales para respuestas asincrónicas.
- Prueba en la plataforma objetivo con `Export Presets` antes de optimizar micro‑perf.

--

**Despliegue**

Antes de exportar:

1. Verifica `user://` funciona en la plataforma objetivo (Android necesita permisos si escribes fuera de sandbox).
2. Añade `*.json` y recursos necesarios en `Export > Resources` si tu export requiere incluir archivos extras.
3. Prueba el guardado/carga completo y el audio en el build final.

--

**Contribuir**

1. Haz fork del repositorio
2. Crea una rama `feature/mi-cambio`
3. Envía Pull Requests con descripción y casos de uso

Por favor, sigue el estilo de código del proyecto y añade ejemplos para cualquier componente nuevo.

--

**Contacto y soporte**

- Issues: `https://github.com/ruichislab/no-code-godot/issues`
- Discord / Comunidad: enlace en la página principal del repo
- Email: support@ruichislab.com

--

Si quieres, puedo añadir ejemplos de escenas listas para abrir (pequeños `*.tscn`) o un repositorio de ejemplo mínimo. ¿Prefieres ejemplos por género (RPG / Platformer / Tycoon / Cartas) o ejemplos técnicos (SaveManager, AI, Performance)?
	 * "hurt" - Personaje recibiendo daño (1-2 frames)
   - Para cada animación:
	 * Selecciona la animación
	 * Arrastra los sprites correspondientes
	 * Ajusta FPS (generalmente 8-12)
5. Configura la animación por defecto:
   - En el Inspector de AnimatedSprite2D
   - Animation: "idle"
   - Playing: ON
```

**Conectar con el Controlador:**

```
1. Selecciona RuichisLab/TopDownController
2. En el Inspector:
   - Animar Sprite: ON
   - Nodo Sprite: Selecciona el AnimatedSprite2D
3. El controlador ahora cambiará automáticamente entre:
   - "idle" cuando está quieto
   - "walk" cuando se mueve
```

##### Opción B: Usar AnimationPlayer (Para animaciones complejas)

```
1. Mantén el Sprite2D original
2. Añade un AnimationPlayer como hijo del Jugador
3. Crea las siguientes animaciones:
   - "idle": Cambia frame_coords del Sprite2D
   - "walk": Secuencia de frames de caminar
   - "attack": Secuencia de ataque
4. Crea un script simple para controlar las animaciones:
```

```gdscript
# En el script del Jugador
@onready var anim_player = $AnimationPlayer
@onready var controller = $TopDownController

func _process(_delta):
	# Detectar movimiento
	var velocity = controller.get_parent().velocity
	
	if velocity.length() > 10:
		anim_player.play("walk")
	else:
		anim_player.play("idle")
	
	# Voltear sprite según dirección
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x < 0
```

##### Consejos para Animaciones:

**Organización de Sprites:**
```
- Usa sprite sheets (hojas de sprites) organizados en filas
- Cada fila = una animación diferente
- Ejemplo:
  Fila 1: idle (4 frames)
  Fila 2: walk (8 frames)
  Fila 3: attack (6 frames)
```

**Configuración Recomendada:**
```
- Tamaño de frame: 32x32, 64x64, o 128x128 píxeles
- FPS de animación:
  * Idle: 6-8 FPS (lento y suave)
  * Walk: 10-12 FPS (natural)
  * Attack: 12-15 FPS (rápido y dinámico)
  * Hurt: 15-20 FPS (muy rápido)
```

**Voltear el Sprite:**
```
El TopDownController automáticamente voltea el sprite
según la dirección de movimiento si:
- Animar Sprite: ON
- El sprite tiene animaciones "walk_right" y "walk_left"
  O usa flip_h automáticamente
```

**Ejemplo de Estructura Final con Animaciones:**
```
Jugador (CharacterBody2D)
├── AnimatedSprite2D
│   └── SpriteFrames (con idle, walk, attack, hurt)
├── CollisionShape2D
├── RuichisLab/TopDownController (Animar Sprite: ON)
├── Estadisticas
├── RuichisLab/Hurtbox
└── RuichisLab/MeleeWeapon
```


#### Paso 4: Añadir Combate

```
1. Añade RuichisLab/MeleeWeapon como hijo del Jugador
2. Crea un Area2D hijo de MeleeWeapon (nómbralo "HitboxArea")
3. Añade RuichisLab/Hitbox a HitboxArea
4. Añade CollisionShape2D a HitboxArea
   - Configura la forma para que coincida con el alcance del arma
   - Posiciónala frente al personaje
5. En el Inspector de MeleeWeapon:
   - Accion Ataque: "attack" (créala en Input Map)
   - Hitbox: Selecciona HitboxArea
   - Tiempo Ataque: 0.3
   - Cooldown: 0.5
6. En el Inspector de Hitbox:
   - Dano: 25
```

**Lo que puedes hacer ahora:** ¡Atacar con tu tecla configurada! ⚔️

##### Animar el Ataque (Opcional pero Recomendado)

Para que el ataque se vea profesional, conecta la animación:

```
1. En el Inspector de RuichisLab/MeleeWeapon:
   - Animacion Ataque: "attack"
   - Nodo Animacion: Selecciona el AnimatedSprite2D
2. El componente reproducirá automáticamente la animación "attack"
   cuando presiones el botón de ataque
3. Asegúrate de que la animación "attack" tenga la duración
   correcta (debe coincidir con Tiempo Ataque: 0.3)
```

**Sincronizar Hitbox con Animación:**

Para que el daño se aplique en el momento exacto del golpe:

```
1. Abre la animación "attack" en el AnimatedSprite2D
2. Identifica el frame donde el arma hace contacto
   (generalmente frame 2 o 3 de 6)
3. En RuichisLab/MeleeWeapon:
   - Tiempo Ataque: Ajusta para que coincida con ese frame
   - Ejemplo: Si el golpe es en frame 3 de 6 frames a 12 FPS
	 Tiempo = 3/12 = 0.25 segundos
```


#### Paso 5: Añadir Retroalimentación Visual

```
1. Añade RuichisLab/HitFlash al Jugador
   - Hace que el sprite parpadee en blanco al recibir daño
2. Añade RuichisLab/Knockback al Jugador
   - Fuerza: 300
   - Duracion: 0.2
   - Empuja al jugador al recibir daño
3. Añade RuichisLab/HealthBar a tu UI
   - Se conectará automáticamente a las estadísticas del jugador
```

**Resultado Final:** Un personaje jugable completo con:
- ✅ Movimiento suave en 8 direcciones
- ✅ Sistema de salud
- ✅ Combate cuerpo a cuerpo
- ✅ Retroalimentación visual de daño
- ✅ Empuje al recibir golpes
- ✅ Barra de vida en pantalla

---

### 🤖 Tutorial 2: Crear un Enemigo

Creemos un enemigo que patrulla y ataca al jugador.

#### Configuración Básica

```
1. Crea CharacterBody2D (nombre: "Enemigo")
2. Añade Sprite2D con textura de enemigo
3. Añade CollisionShape2D
4. Añádelo al grupo "enemigos"
```

#### Añadir Salud y Daño

```
1. Añade nodo Estadisticas (Salud Maxima: 50)
2. Añade RuichisLab/Hurtbox
3. Crea Area2D hijo (nombre: "AreaAtaque")
4. Añade RuichisLab/Hitbox a AreaAtaque (Dano: 10)
5. Añade CollisionShape2D a AreaAtaque
```

#### Añadir Comportamiento de IA

```
1. Añade RuichisLab/Patrol al Enemigo
   - Crea 2-3 Marker2D hijos como waypoints
   - Velocidad: 100
2. Añade RuichisLab/Follower al Enemigo
   - Distancia Activacion: 200
   - Velocidad: 150
```

**Comportamiento:** ¡El enemigo patrulla y persigue al jugador cuando está cerca! 🏃

---

### 🚪 Tutorial 3: Puerta con Llave

Sistema clásico de puerta cerrada estilo Zelda.

#### La Llave

```
1. Crea Area2D (nombre: "LlaveRoja")
2. Añade Sprite2D con textura de llave
3. Añade RuichisLab/Key
4. Configura:
   - Variable A Activar: "tiene_llave_roja"
```

#### La Puerta

```
1. Crea StaticBody2D (nombre: "PuertaRoja")
2. Añade Sprite2D con textura de puerta
3. Añade RuichisLab/Door
4. Configura:
   - Variable Requerida: "tiene_llave_roja"
```

**Funcionamiento:**
1. Jugador recoge llave → Variable "tiene_llave_roja" = true
2. Jugador se acerca a puerta → Puerta verifica variable
3. Si es verdadera → Puerta se abre
4. Si es falsa → Muestra mensaje "Necesitas Llave Roja"

---
### 🎮 Tutorial 4: Menú Principal

Crea una interfaz de menú principal profesional y totalmente funcional.

#### Paso 1: Estructura Base
1. Añade un nodo **Control** llamado `MainMenu`.
2. Dentro, inserta un **TextureRect** como fondo y asigna una textura de fondo atractiva.
3. Añade un **VBoxContainer** centrado para organizar los botones.

#### Paso 2: Botones del Menú
En el `VBoxContainer` crea los siguientes **Button**:
- **Nuevo Juego** (`id="btn_new_game"`): inicia la escena del juego.
- **Cargar** (`id="btn_load"`): abre un menú de guardado.
- **Opciones** (`id="btn_options"`): muestra ajustes de audio y video.
- **Salir** (`id="btn_quit"`): cierra la aplicación.

Conecta cada botón a un script `MainMenu.gd` que use los componentes `RuichisLab/SignalEmitter` o `RuichisLab/Action` para cambiar de escena o ejecutar funciones.

#### Paso 3: Animaciones y Sonido
- Añade un **AnimationPlayer** al nodo `MainMenu` con animaciones de aparición (`fade_in`) y pulsación (`button_press`).
- Usa **AudioStreamPlayer** para reproducir efectos al pasar el cursor (`hover`) y al pulsar (`click`).

#### Paso 4: Transición a la Escena del Juego
En `MainMenu.gd`:
```gdscript
func _on_btn_new_game_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")
```
Utiliza el componente `RuichisLab/Transition` para añadir efectos de fundido.

---
### 📊 Tutorial 5: HUD en Juego

Implementa una interfaz de usuario (HUD) que muestra información esencial al jugador.

#### Paso 1: Nodo CanvasLayer
Crea un nodo **CanvasLayer** llamado `HUD` para que siempre se dibuje sobre la escena del juego.

#### Paso 2: Barra de Salud
1. Añade un **TextureProgress** (`id="health_bar"`).
2. Asigna una textura de fondo y una de relleno.
3. Configura `max_value` al máximo de vida del jugador y enlaza su `value` al componente `RuichisLab/Health`.

#### Paso 3: Indicador de Puntuación
- Añade un **Label** (`id="score_label"`).
- En el script del jugador, actualiza `score_label.text = str(puntuacion)` cada vez que el jugador gana puntos.

#### Paso 4: Mini‑Mapa (Opcional)
- Usa un **TextureRect** con una vista reducida del nivel.
- Conecta su posición al nodo del jugador para que siga al personaje.

#### Paso 5: Pausa y Menú
- Añade un **Control** oculto llamado `PauseMenu`.
- En el script de HUD, muestra/oculta `PauseMenu` al pulsar **Esc** y pausa el juego con `get_tree().paused = true`.

#### Paso 6: Integración con Componentes
Utiliza los componentes **RuichisLab/SignalEmitter** para que eventos como `player_died` o `level_complete` actualicen automáticamente el HUD sin código adicional.

---

## 📦 Biblioteca de Componentes

### 🕹️ Controladores (Movimiento)

| Componente | Descripción | Mejor Para |
|-----------|-------------|-----------|
| **TopDownController** | Movimiento 8 direcciones con aceleración | RPGs, Twin-stick shooters |
| **PlatformerController** | Físicas precisas de plataformas (estilo Celeste) | Plataformas, Metroidvanias |
| **CarController** | Físicas arcade de coche con derrapes | Juegos de carreras |
| **GridMovement** | Movimiento basado en casillas | RPGs Tácticos, Roguelikes |

### ⚔️ Sistema de Combate

| Componente | Descripción | Uso |
|-----------|-------------|-----|
| **Hurtbox** | Recibe daño | Añadir a jugador/enemigos |
| **Hitbox** | Causa daño | Añadir a armas/proyectiles |
| **MeleeWeapon** | Sistema de ataque cuerpo a cuerpo | Combate del jugador |
| **Proyectil** | Proyectil de bala/flecha | Combate a distancia |
| **Dash** | Habilidad de esquiva/rodar | Movilidad del jugador |
| **Knockback** | Empuje al recibir golpe | Retroalimentación de combate |

### 🧠 IA y NPCs

| Componente | Descripción | Uso |
|-----------|-------------|-----|
| **Patrol** | Patrullaje por waypoints | Guardias, enemigos |
| **Follower** | Perseguir objetivo | Enemigos agresivos, mascotas |
| **MaquinaEstados** | Máquina de estados | IA compleja |
| **BehaviorTree** | Árbol de decisión de IA | IA avanzada |

### 💬 Diálogos y Misiones

| Componente | Descripción | Uso |
|-----------|-------------|-----|
| **SimpleDialog** | Popup de texto básico | Carteles, pistas |
| **AdvancedDialog** | Sistema completo de diálogos | Conversaciones con NPCs |
| **QuestGiver** | Dar misiones | NPCs de misiones |
| **QuestObjective** | Objetivos de misión | Coleccionables, enemigos |

### 🌍 Construcción de Mundos

| Componente | Descripción | Uso |
|-----------|-------------|-----|
| **LevelPortal** | Cambiar escenas | Transiciones de nivel |
| **Teleporter** | Teletransporte instantáneo | Portales, warps |
| **SavePoint** | Guardar partida | Puntos de control |
| **CameraZone** | Límites de cámara | Transiciones de habitación |
| **DayNightCycle** | Sistema día/noche | Mundos abiertos |
| **Weather** | Efectos de lluvia/nieve | Atmósfera |

---

## 🎨 Ejemplos Prácticos

### Ejemplo 1: Nivel de Plataformas Simple

```
Estructura de Escena:
├── Nivel (Node2D)
│   ├── Jugador (CharacterBody2D)
│   │   ├── RuichisLab/PlatformerController
│   │   ├── RuichisLab/Hurtbox
│   │   └── RuichisLab/Dash
│   ├── Plataformas (StaticBody2D x varios)
│   ├── Monedas (Area2D x varios)
│   │   └── RuichisLab/Collectible
│   └── Meta (Area2D)
│       └── RuichisLab/LevelPortal
```

### Ejemplo 2: Habitación RPG Top-Down

```
Estructura de Escena:
├── Habitacion (Node2D)
│   ├── Jugador (CharacterBody2D)
│   │   ├── RuichisLab/TopDownController
│   │   └── RuichisLab/MeleeWeapon
│   ├── Enemigos (CharacterBody2D x 3)
│   │   ├── RuichisLab/Patrol
│   │   └── RuichisLab/Follower
│   ├── Cofre (Area2D)
│   │   └── RuichisLab/ItemChest
│   └── NPC (Area2D)
│       └── RuichisLab/AdvancedDialog
```

---

## 🛠️ Uso Avanzado

### Crear Acciones Personalizadas

```gdscript
# AccionCurar.gd
class_name AccionCurar
extends GameAction

@export var cantidad: int = 10

func ejecutar(actor: Node):
	var stats = actor.get_node_or_null("Estadisticas")
	if stats:
		stats.curar(cantidad)
```

¡Ahora esta acción aparece en todos los componentes `RuichisLab/Trigger`!

---

## 🚢 Publicar Tu Juego

### Lista de Verificación de Exportación

- [ ] Probar en plataforma objetivo
- [ ] Configurar presets de exportación
- [ ] Incluir `*.json` en filtro de exportación
- [ ] Configurar permisos apropiados (móvil)
- [ ] Crear iconos de aplicación
- [ ] Verificar sistema de guardado/carga
- [ ] Comprobar que el audio funciona

### Plataformas Soportadas

- ✅ Windows (64-bit)
- ✅ Linux
- ✅ macOS
- ✅ Web (HTML5)
- ✅ Android
- ✅ iOS

---

## 🏆 Mejores Prácticas

### Organización del Proyecto

```
res://
├── Escenas/
│   ├── Niveles/
│   ├── Personajes/
│   └── UI/
├── Recursos/
│   ├── Dialogos/
│   ├── Misiones/
│   └── Items/
└── addons/
	└── no_code_godot_plugin/
```

### Convenciones de Nomenclatura

- **Variables:** `quest_`, `flag_`, `count_`, `has_`
- **Escenas:** PascalCase (PersonajeJugador.tscn)
- **Recursos:** Nombres descriptivos (dialogo_anciano_saludo.tres)

---

## 📦 Tutorial: Crear un Inventario en 5 Minutos

### La Forma MÁS FÁCIL (Sin Código)

#### Paso 1: Crear un Item Básico (30 segundos)

1. Carpeta: `res://Recursos/Items/`
2. Clic derecho → **Nuevo Recurso** → Tipo: `RecursoObjeto`
3. Guardar como: `pocion.tres`
4. En el Inspector, solo rellena:
   - **Nombre:** "Poción de Vida"
   - **Icono:** Arrastra una imagen pequeña (32x32)
5. **Guardar** ✅

¡Listo! Ya tienes tu primer objeto.

#### Paso 2: Poner el Item en el Juego (1 minuto)

En tu escena de nivel:

```
Level (Node2D)
├── Jugador (CharacterBody2D)
└── ItemPocion (Area2D) ← Clic derecho: Nodo nuevo
    ├── Sprite2D (arrastra sprite de poción)
    ├── CollisionShape2D (crea círculo o caja)
    └── [AGREGAR COMPONENTE] → RuichisLab/Collectible
```

En el Inspector de `Collectible`:
- **Item:** Selecciona `pocion.tres` (arrastra desde carpeta o clic en selector)
- **Sonido:** `item_pickup` (o déjalo vacío)

**¡Hecho!** Al tocar el jugador, recoge la poción. ✅

#### Paso 3: Ver el Inventario en Pantalla (2 minutos)

Opción A: **UI Simple (Recomendado para principiantes)**

```
Canvas (CanvasLayer)
├── PanelInventario (Panel o ColorRect)
│   └── VBoxContainer
│       ├── Label "Inventario"
│       └── GridContainer (columnas: 5)
│           └── [Agrega 20 TextureButtons vacíos - copiar/pegar]
└── Botón Cerrar
```

**Por qué es tan fácil:** Los botones no necesitan script, solo muestran los items que el jugador recogió. El plugin maneja todo automáticamente.

Opción B: **UI Profesional (Con un poco más de detalle)**

Igual que Opción A, pero agrega un panel lateral:

```
PanelDetalles (Panel)
├── TextureRect [Icono del item seleccionado]
├── Label [Nombre del item]
├── Label [Cantidad: x5]
└── Button [Usar] / [Descartar]
```

#### Paso 4: ¡Prueba! (10 segundos)

```
Presiona F5 o Reproducir
→ Camina hacia la poción
→ ¡Recógela!
→ Abre el inventario
→ ¡Ve tu poción en el inventario!
```

### Tabla Rápida: Lo Que Necesitas Saber

| Quiero... | Pasos |
|-----------|-------|
| **Crear un item** | Nuevo Recurso `RecursoObjeto` + nombre + icono |
| **Ponerlo en el suelo** | Area2D + Sprite + Collectible |
| **Que el jugador lo recoja** | Collectible toca al jugador (automático) |
| **Mostrarlo en pantalla** | GridContainer con TextureButtons (la UI hace el trabajo) |
| **Usarlo/Consumirlo** | Crea un Trigger con Acción (o script simple) |
| **Guardarlo** | SaveManager lo hace automáticamente |

### Ejemplo Listo Para Copiar-Pegar

**RecursoObjeto - pocion.tres:**
```
[resource type="RecursoObjeto" format=3]

nombre = "Poción de Vida"
descripcion = "Restaura 50 HP"
cantidad_maxima = 99
es_consumible = true
precio_venta = 50
```

**Escena ItemPocion.tscn:**
```
[gd_scene load_steps=3 format=3]

[sub_resource type="CircleShape2D" id="1"]
radius = 16.0

[gd_scene_load_steps=4 format=3]
[ext_resource type="Texture2D" path="res://assets/pocion.png"]
[ext_resource type="Script" path="res://addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd"]

[node name="ItemPocion" type="Area2D"]
[node name="Sprite2D" type="Sprite2D" parent="."]
texture = ExtResource("1")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("1")

[node name="ComponenteCollectible" type="Node" parent="."]
script = ExtResource("2")
sonido_recoger = "item_pickup"
```

### Tips Para Ir Más Lejos

**Quiero que al usar la poción, el jugador se cure:**

1. Crea un nuevo Trigger en el botón "Usar"
2. Dentro del Trigger, agrega esta Acción simple:
   ```
   RuichisLab/Trigger → Ejecutar
   → Acción: "Curar" (o crea una personalizada)
   → Cantidad: 50
   ```

**Quiero que cada item tenga cantidad límite:**
- En `RecursoObjeto`, cambia **Cantidad Máxima:** (ej: 99)
- Al recoger más de lo máximo, simplemente no se recoge

**Quiero que aparezca un contador (x5 items):**
- En el GridContainer, agrega un Label pequeño en cada slot
- Script simple (1 línea): `label.text = str(item_cantidad)`

**Quiero diferentes tipos de items (equipo, consumibles, quest items):**
- Crea variantes de `RecursoObjeto`:
  - `RecursoEquipo` (espadas, armaduras) - modifica stats
  - `RecursoConsumible` (pociones) - se usan y desaparecen
  - `RecursoMision` (llaves) - solo cuentan para misiones

---

## 📦 Tutorial: Crear un Sistema de Inventario Completo

### Forma Avanzada (Si Quieres Más Control)

Si los 5 minutos anteriores te quedaron cortos, aquí va lo avanzado:

### Paso 1: Crear Recursos de Objetos

Primero, define qué objetos puede tener el jugador:

**1. Crear RecursoObjeto.tres:**
- En el explorador de archivos: `res://Recursos/Items/`
- Clic derecho → **Nuevo Recurso**
- Tipo: `RecursoObjeto`
- Nombre: `pocion_vida.tres`
- En el Inspector, configura:
  - **Nombre:** "Poción de Vida"
  - **Descripción:** "Restaura 50 HP al usarla"
  - **Icono:** Arrastra una imagen de poción (32x32 recomendado)
  - **Cantidad Máxima:** 99
  - **Es Consumible:** ON
  - **Precio de Venta:** 50

Repite para otros objetos: `espada_hierro.tres`, `escudo_madera.tres`, `llave_oro.tres`, etc.

### Paso 2: Crear la UI del Inventario

**1. Crear escena Inventario.tscn:**
```
Inventario (CanvasLayer)
├── Panel (para fondo)
├── GridContainer (para mostrar slots)
│   └── TextureButton x 20 (slots vacíos)
├── PanelDetalles (Panel para mostrar detalles del objeto seleccionado)
│   ├── TextureRect (para el icono)
│   ├── Label (nombre del objeto)
│   ├── Label (descripción)
│   └── Button ("Usar" o "Descartar")
└── Cerrar (Button para cerrar el inventario)
```

**2. Configurar GridContainer:**
- **Columns:** 5
- **Size Flags:** Horizontal → FILL, Vertical → FILL

### Paso 3: Añadir el Inventario al Jugador

**1. Crear escena Jugador.tscn:**
```
Jugador (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── TopDownController (RuichisLab/TopDownController)
├── Hurtbox (RuichisLab/Hitbox)
├── Estadisticas (RuichisLab/Estadisticas)
└── UIInventario (instancia de Inventario.tscn) ← Aquí
```

**2. Conectar el inventario al jugador:**
- Selecciona `Jugador → UIInventario`
- En el Inspector, crea un script simple (o usa uno existente)

### Paso 4: Script del Inventario (Opcional - Sin código si usas triggers)

Si prefieres **sin código**, usa el sistema de Triggers:

**Recoger un objeto:**
- Añade `RuichisLab/Collectible` al objeto en el suelo
- En el Inspector:
  - **Item a Recoger:** Selecciona `pocion_vida.tres`
  - **Sonido:** "item_pickup"
  - **Acción al Recoger:** Trigger → Ejecutar → Acción Inventario (Añadir)

**Usar un objeto desde el inventario:**
- Crea un Button "Usar"
- Conecta su señal `pressed` a un Trigger
- En el Trigger, crea una Acción que:
  - Ejecute el efecto del objeto (curación, buff, etc.)
  - Elimine el objeto del inventario

### Ejemplo Completo: Sistema de Pociones

**Escena Poción en el Suelo:**
```
ItemPocion (Area2D)
├── Sprite2D (con textura de poción)
├── CollisionShape2D
├── RuichisLab/Collectible
│   ├── Item: pocion_vida.tres
│   └── Sonido: "item_pickup"
└── Trigger
    └── Acción: Inventario.Añadir(pocion_vida, 1)
```

**Escena Interfaz del Inventario:**
```
CanvasLayer
├── Inventario (GridContainer con 20 slots)
└── Para cada slot:
    ├── TextureButton (muestra icono del objeto)
    └── Label (muestra cantidad)
```

**Usar la Poción (usando Variables del Plugin):**
1. Al hacer clic en "Usar":
   - **Restar cantidad** del inventario
   - **Ejecutar efecto**: `GameManager.curar_jugador(50)`
   - **Reproducir sonido**: `SoundManager.play_sfx("pocion_use")`
   - **Efecto visual**: Mostrar partículas/floatingtext

### Paso 5: Guardar el Inventario

El plugin **automaticamente guarda** los estados de las variables. Para asegurar que el inventario se guarda:

1. Ve a `Proyecto → Configuración del Proyecto → Autoload`
2. Verifica que `SaveManager` esté cargado
3. El inventario se guardará automáticamente en `user://saves/`

Para acceder al inventario guardado desde un script:
```gdscript
var datos_guardados = SaveManager.cargar_juego()
# datos_guardados["inventario"] = [...]
```

### Tips: Inventario Avanzado

**Limitar por peso:**
- Crea una variable global `peso_actual: int`
- Cada objeto tiene un peso exportado
- Antes de recoger, valida: `if peso_actual + peso_objeto <= 50: recoger()`

**Sistema de Equipo:**
- Crea slots especiales: "Arma Mano Derecha", "Armadura", etc.
- Al equipo un objeto, resta del inventario y suma a "Equipo"
- Los objetos equipados modifican stats (`Estadisticas.fuerza += 5`)

**Craft/Combinación:**
- Define recetas en recursos: `RecetaForja.tres`
- UI con lista de recetas posibles
- Trigger valida: "¿Tengo los materiales?" → Crea nuevo objeto

**Ordenamiento:**
- Botón "Ordenar": reorganiza slots eliminando huecos
- Botón "Descartar": quita objeto del inventario (dropea en el suelo o destruye)

---

## 📞 Soporte

- 📧 **Email:** support@ruichislab.com

---

## 📜 Licencia

```
MIT License - Copyright (c) 2024 Ruichis Lab

Se concede permiso para usar, copiar, modificar y distribuir este software
de forma gratuita, incluyendo uso comercial.
```

---

<div align="center">

**Hecho con ❤️ por Ruichis Lab**

*Empoderando a creadores para construir juegos increíbles sin código*

[⬆ Volver Arriba](#-ruichislab-framework)

</div>
