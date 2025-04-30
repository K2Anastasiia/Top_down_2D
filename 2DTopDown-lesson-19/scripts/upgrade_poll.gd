class_name UpgradePoll

var upgrades: Array[Dictionary] = []
var weight_sum = 0

func add_upgrade(upgrade, weight: int):
	upgrades.append({"upgrade": upgrade, "weight": weight})
	weight_sum += weight
	
func remove_upgrade(applied_upgrade):
	upgrades = upgrades.filter(func(upgrade): return upgrade["upgrade"] != applied_upgrade)
	weight_sum = 0
	for upgrade in upgrades:
		weight_sum += upgrade["weight"]
	
func pick_upgrade(chosen_upgrades: Array):
	var update_upgrades: Array[Dictionary] = upgrades
	var upgrade_weight_sum = weight_sum
	
	if chosen_upgrades.size() > 0:
		update_upgrades = []
		upgrade_weight_sum = 0
		for upgrade in upgrades:
			if upgrade["upgrade"] in chosen_upgrades:
				continue
			update_upgrades.append(upgrade)
			upgrade_weight_sum += upgrade["weight"]
			
	
	var random_weight = randi_range(1, upgrade_weight_sum)
	for upgrade in update_upgrades:
		random_weight -= upgrade["weight"]
		if random_weight <= 0:
			return upgrade["upgrade"]
	
