class_name Shop extends CanvasLayer

var is_open := false

signal shop_closed

@onready var money_label: Label = $CenterContainer/Panel/VBoxContainer/MoneyLabel
@onready var shell_buy_button: Button = $CenterContainer/Panel/VBoxContainer/ShellRow/ShellBuyButton
@onready var repair_kit_buy_button: Button = $CenterContainer/Panel/VBoxContainer/RepairRow/RepairBuyButton
@onready var radio_buy_button: Button = $CenterContainer/Panel/VBoxContainer/RadioRow/RadioBuyButton
@onready var close_button: Button = $CenterContainer/Panel/VBoxContainer/CloseButton
@onready var shell_count_label: Label = $CenterContainer/Panel/VBoxContainer/ShellRow/ShellCount
@onready var repair_kit_count_label: Label = $CenterContainer/Panel/VBoxContainer/RepairRow/RepairCount
@onready var radio_count_label: Label = $CenterContainer/Panel/VBoxContainer/RadioRow/RadioCount

var shell_price := 3
var repair_kit_price := 5
var radio_price := 7

func _ready():
	shell_buy_button.pressed.connect(_buy_shells)
	repair_kit_buy_button.pressed.connect(_buy_repair_kit)
	radio_buy_button.pressed.connect(_buy_radio)
	close_button.pressed.connect(_close)
	visible = false

func open():
	is_open = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_refresh()

func _close():
	is_open = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	shop_closed.emit()

func _refresh():
	money_label.text = "Деньги: $%d" % GameModeManager.instance.inventory_manager.money
	shell_count_label.text = "x%d" % GameModeManager.instance.inventory_manager.shotgun_shells
	repair_kit_count_label.text = "x%d" % GameModeManager.instance.inventory_manager.cam_repair_kit
	radio_count_label.text = "x%d" % GameModeManager.instance.inventory_manager.radio

	shell_buy_button.disabled = GameModeManager.instance.inventory_manager.money < shell_price
	repair_kit_buy_button.disabled = GameModeManager.instance.inventory_manager.money < repair_kit_price
	radio_buy_button.disabled = GameModeManager.instance.inventory_manager.money < radio_price

func _buy_shells():
	if GameModeManager.instance.inventory_manager.money >= shell_price:
		GameModeManager.instance.inventory_manager.money -= shell_price
		GameModeManager.instance.inventory_manager.shotgun_shells += 1
		_refresh()

func _buy_repair_kit():
	if GameModeManager.instance.inventory_manager.money >= repair_kit_price:
		GameModeManager.instance.inventory_manager.money -= repair_kit_price
		GameModeManager.instance.inventory_manager.cam_repair_kit += 1
		_refresh()

func _buy_radio():
	if GameModeManager.instance.inventory_manager.money >= radio_price:
		GameModeManager.instance.inventory_manager.money -= radio_price
		GameModeManager.instance.inventory_manager.radio += 1
		_refresh()
