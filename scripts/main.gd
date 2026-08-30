extends Node3D

const FIGHTERS = [
    ["Goku", Color(1.0,0.25,0.05), "Kamehameha"],
    ["Vegeta", Color(0.15,0.35,1.0), "Final Flash"],
    ["Gohan", Color(1.0,0.75,0.25), "Masenko"],
    ["Broly", Color(0.15,1.0,0.25), "Gigantic Roar"],
    ["Frieza", Color(0.75,0.45,1.0), "Death Beam"],
    ["Jiren", Color(1.0,0.15,0.18), "Power Impact"],
    ["Beerus", Color(0.65,0.25,0.85), "Hakai"],
    ["Gogeta", Color(0.2,0.75,1.0), "Stardust Breaker"],
    ["Vegito", Color(0.2,0.55,1.0), "Final Kamehameha"],
    ["Hit", Color(0.4,0.2,0.55), "Time-Skip"]
]

var selected := 0
var player: Node3D
var enemy: Node3D
var camera: Camera3D
var ui: Control
var hp := 100.0
var enemy_hp := 100.0
var ki := 100.0
var locked := false
var aura := false
var status := "اختر مقاتلك"

func _ready():
    show_select()

func show_select():
    for n in get_children():
        n.queue_free()
    var c = Control.new()
    c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(c)
    ui = c

    var bg = ColorRect.new()
    bg.color = Color(0.015,0.02,0.06)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    c.add_child(bg)

    var title = Label.new()
    title.text = "ANIME DRAGON SUPER 3D"
    title.position = Vector2(0,30)
    title.size = Vector2(1280,60)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size",38)
    c.add_child(title)

    var hint = Label.new()
    hint.text = "10 مقاتلين • قتال سريع • حركات خاصة • Ultimate"
    hint.position = Vector2(0,90)
    hint.size = Vector2(1280,40)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    c.add_child(hint)

    for i in range(FIGHTERS.size()):
        var b = Button.new()
        b.text = str(i+1) + "  " + FIGHTERS[i][0]
        b.position = Vector2(100 + (i % 5) * 220, 160 + int(i / 5) * 110)
        b.size = Vector2(190,80)
        b.add_theme_font_size_override("font_size",20)
        b.pressed.connect(func(): start_battle(i))
        c.add_child(b)

    var info = Label.new()
    info.text = "PC: WASD حركة | J لكمة | K هالة | L خاصة | U Ultimate | Space Lock-on\nAndroid: أزرار لمس داخل المعركة\nالصوت: الواجهة مجهزة لأوامر عربية مثل «لكمة»، «هالة»، «حركة خاصة» عند ربط Speech plugin."
    info.position = Vector2(80,410)
    info.size = Vector2(1120,130)
    info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info.add_theme_font_size_override("font_size",18)
    c.add_child(info)

func start_battle(i:int):
    selected = i
    for n in get_children():
        n.queue_free()
    build_world()

func build_world():
    var env = WorldEnvironment.new()
    var e = Environment.new()
    e.background_mode = Environment.BG_COLOR
    e.background_color = Color(0.02,0.04,0.10)
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.45,0.5,0.7)
    e.ambient_light_energy = 1.3
    env.environment = e
    add_child(env)

    var light = DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-55,-30,0)
    light.light_energy = 1.5
    add_child(light)

    var floor = MeshInstance3D.new()
    var mesh = PlaneMesh.new()
    mesh.size = Vector2(50,50)
    floor.mesh = mesh
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.06,0.08,0.13)
    mat.metallic = 0.25
    floor.material_override = mat
    add_child(floor)

    player = fighter(Vector3(-5,1,0), FIGHTERS[selected])
    enemy = fighter(Vector3(5,1,0), FIGHTERS[(selected+1)%FIGHTERS.size()])
    add_child(player)
    add_child(enemy)

    camera = Camera3D.new()
    add_child(camera)
    camera.current = true

    build_ui()

func fighter(pos:Vector3, data:Array) -> Node3D:
    var root = Node3D.new()
    root.position = pos
    root.set_meta("color", data[1])

    var body = MeshInstance3D.new()
    var cm = CapsuleMesh.new()
    cm.height = 2.2
    cm.radius = 0.55
    body.mesh = cm
    var bm = StandardMaterial3D.new()
    bm.albedo_color = data[1]
    bm.emission_enabled = true
    bm.emission = data[1] * 0.12
    body.material_override = bm
    root.add_child(body)

    var head = MeshInstance3D.new()
    var sm = SphereMesh.new()
    sm.radius = 0.45
    sm.height = 0.9
    head.mesh = sm
    var hm = StandardMaterial3D.new()
    hm.albedo_color = Color(1,0.72,0.55)
    head.material_override = hm
    head.position.y = 1.45
    root.add_child(head)
    return root

func build_ui():
    ui = Control.new()
    ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(ui)

    var hpbar = ProgressBar.new()
    hpbar.name = "HP"
    hpbar.position = Vector2(30,25)
    hpbar.size = Vector2(450,30)
    hpbar.max_value = 100
    hpbar.value = hp
    ui.add_child(hpbar)

    var ehp = ProgressBar.new()
    ehp.name = "EHP"
    ehp.position = Vector2(800,25)
    ehp.size = Vector2(450,30)
    ehp.max_value = 100
    ehp.value = enemy_hp
    ui.add_child(ehp)

    var label = Label.new()
    label.name = "Status"
    label.position = Vector2(0,65)
    label.size = Vector2(1280,55)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size",22)
    ui.add_child(label)

    var names = ["لكمة","هالة","خاصة","Ultimate"]
    for i in range(4):
        var b = Button.new()
        b.text = names[i]
        b.position = Vector2(25+i*170,610)
        b.size = Vector2(150,70)
        b.add_theme_font_size_override("font_size",20)
        var action = ["attack","aura","special","ultimate"][i]
        b.pressed.connect(func(): action_do(action))
        ui.add_child(b)

    var lock = Button.new()
    lock.text = "Lock-on"
    lock.position = Vector2(700,610)
    lock.size = Vector2(150,70)
    lock.pressed.connect(func(): locked = not locked)
    ui.add_child(lock)

    var back = Button.new()
    back.text = "القائمة"
    back.position = Vector2(1020,610)
    back.size = Vector2(180,70)
    back.pressed.connect(show_select)
    ui.add_child(back)

func _process(delta):
    if not player or not enemy:
        return
    var move = Vector3.ZERO
    move.x = Input.get_axis("move_left","move_right")
    move.z = Input.get_axis("move_forward","move_back")
    if move.length() > 0:
        player.position += move.normalized() * 5.5 * delta
    if locked:
        player.look_at(enemy.position, Vector3.UP)

    if Input.is_action_just_pressed("attack"): action_do("attack")
    if Input.is_action_just_pressed("aura"): action_do("aura")
    if Input.is_action_just_pressed("special"): action_do("special")
    if Input.is_action_just_pressed("ultimate"): action_do("ultimate")
    if Input.is_action_just_pressed("lock_on"): locked = not locked

    enemy.look_at(player.position, Vector3.UP)
    var mid = (player.position + enemy.position) * 0.5
    var dist = player.position.distance_to(enemy.position)
    camera.position = camera.position.lerp(mid + Vector3(0,4.5,max(9.0,dist*0.8)),0.12)
    camera.look_at(mid + Vector3(0,1,0),Vector3.UP)

    if ui:
        ui.get_node("HP").value = hp
        ui.get_node("EHP").value = enemy_hp
        ui.get_node("Status").text = FIGHTERS[selected][0] + " | " + status + " | KI " + str(int(ki)) + " | Lock " + ("ON" if locked else "OFF")
    ki = min(100.0,ki+delta*2.0)

func action_do(action:String):
    if action == "attack":
        status = "لكمة سريعة!"
        enemy_hp = max(0,enemy_hp-7)
        flash(enemy.position,FIGHTERS[selected][1])
    elif action == "aura":
        aura = not aura
        status = "الهالة ظهرت!" if aura else "الهالة اختفت!"
        if aura:
            var l = OmniLight3D.new()
            l.name = "AuraLight"
            l.light_color = FIGHTERS[selected][1]
            l.light_energy = 5
            l.omni_range = 7
            player.add_child(l)
        elif player.has_node("AuraLight"):
            player.get_node("AuraLight").queue_free()
    elif action == "special":
        if ki < 20:
            status = "KI غير كافي!"
            return
        ki -= 20
        status = str(FIGHTERS[selected][2]) + "!"
        enemy_hp = max(0,enemy_hp-20)
        beam(player.position,enemy.position,FIGHTERS[selected][1])
    elif action == "ultimate":
        if ki < 60:
            status = "تحتاج 60 KI!"
            return
        ki -= 60
        status = "ULTIMATE!!!"
        enemy_hp = max(0,enemy_hp-50)
        beam(player.position,enemy.position,Color(1,0.85,0.2))
    if enemy_hp <= 0:
        status = "انتصرت! 🔥"

func flash(pos:Vector3,color:Color):
    var f = MeshInstance3D.new()
    var s = SphereMesh.new()
    s.radius = 0.35
    s.height = 0.7
    f.mesh = s
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    m.emission_enabled = true
    m.emission = color*3
    f.material_override = m
    f.position = pos + Vector3(0,1,0)
    add_child(f)
    var t = create_tween()
    t.tween_property(f,"scale",Vector3.ONE*4,0.14)
    t.tween_callback(f.queue_free)

func beam(a:Vector3,b:Vector3,color:Color):
    var f = MeshInstance3D.new()
    var c = CylinderMesh.new()
    c.height = a.distance_to(b)
    c.top_radius = 0.16
    c.bottom_radius = 0.16
    f.mesh = c
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    m.emission_enabled = true
    m.emission = color*4
    f.material_override = m
    f.position = (a+b)/2 + Vector3(0,1,0)
    f.look_at(b+Vector3(0,1,0),Vector3.UP)
    f.rotate_object_local(Vector3.RIGHT,PI/2)
    add_child(f)
    var t = create_tween()
    t.tween_property(f,"scale",Vector3(1,1,0.05),0.22)
    t.tween_callback(f.queue_free)
