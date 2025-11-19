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

### Tu Primer Juego en 5 Minutos

Creemos un personaje jugable con movimiento y combate:

```
1. Crea una escena con CharacterBody2D como raíz
2. Añade Sprite2D y CollisionShape2D
3. Añade componente RuichisLab/TopDownController
4. Añade componente RuichisLab/Hurtbox
5. Añade componente RuichisLab/MeleeWeapon
6. Presiona F5 - ¡Ya tienes un personaje jugable! ✨
```

---

## 📚 Tutoriales Paso a Paso

### 🎮 Tutorial 1: Crear un Personaje Jugable

Construyamos un personaje completo con movimiento, salud y combate.

#### Paso 1: Configurar el Cuerpo del Personaje

```
1. Crea una nueva escena (Escena > Nueva Escena)
2. Añade un nodo CharacterBody2D (nómbralo "Jugador")
3. Añade un Sprite2D como hijo
   - Asigna la textura de tu personaje
4. Añade un CollisionShape2D como hijo
   - Configura la forma a CapsuleShape2D
   - Ajusta el tamaño al sprite
5. Añade el Jugador al grupo "jugador"
   - Selecciona nodo Jugador > pestaña Nodo > Grupos
   - Escribe "jugador" y haz clic en Añadir
```

#### Paso 2: Añadir Movimiento

```
1. Selecciona el nodo Jugador
2. Haz clic en el botón "+" (Añadir Nodo Hijo)
3. Busca "RuichisLab/TopDownController"
4. Añádelo a la escena
5. En el Inspector, configura:
   - Velocidad Maxima: 300
   - Aceleracion: 1500
   - Friccion: 1000
   - Animar Sprite: ON (si usas AnimatedSprite2D)
```

**Lo que puedes hacer ahora:** ¡Moverte con WASD o las flechas! 🎮

#### Paso 3: Añadir Sistema de Salud

```
1. Selecciona el nodo Jugador
2. Añade un nodo hijo: "Estadisticas" (script personalizado)
   - O crea un Node y adjunta Estadisticas.gd
3. Configura en el Inspector:
   - Salud Maxima: 100
   - Salud Actual: 100
4. Añade RuichisLab/Hurtbox como hijo del Jugador
5. En el Inspector de Hurtbox:
   - Nodo Estadisticas: "../Estadisticas"
```

**Lo que puedes hacer ahora:** ¡Tu personaje puede recibir daño! 💔

#### Paso 3.5: Configurar Animaciones del Jugador

Para que el personaje tenga animaciones suaves, necesitamos configurar un AnimatedSprite2D.

##### Opción A: Usar AnimatedSprite2D (Recomendado para principiantes)

```
1. ELIMINA el Sprite2D que añadiste antes
2. Añade un AnimatedSprite2D como hijo del Jugador
3. En el Inspector de AnimatedSprite2D:
   - Haz clic en "Sprite Frames" > "New SpriteFrames"
   - Haz clic en el recurso SpriteFrames para editarlo
4. En el panel SpriteFrames (parte inferior):
   - Crea las siguientes animaciones:
     * "idle" - Personaje quieto (1-4 frames)
     * "walk" - Personaje caminando (4-8 frames)
     * "attack" - Personaje atacando (3-6 frames)
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

## 📞 Soporte

- 📧 **Email:** support@ruichislab.com
- 💬 **Discord:** [Únete a nuestra comunidad](https://discord.gg/ruichislab)
- 🐛 **Issues:** [GitHub Issues](https://github.com/ruichislab/no-code-godot/issues)
- 📖 **Docs:** [Documentación Completa](https://docs.ruichislab.com)

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
