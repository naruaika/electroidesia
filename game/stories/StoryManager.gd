extends Node

var _story_path = "game/stories/stories.dat"
var stories_reference
var story_number

func _ready() -> void:
	# Load stories.dat file
	var f = File.new()
	f.open(_story_path, File.READ)
	stories_reference = parse_json(f.get_as_text())
	f.close()

func tell_story(default_dialogue: Array = []) -> void:
	if !default_dialogue:
		# Show current story
		get_node("/root/Adventure/HUD").show_dialogues(stories_reference[str(story_number)])
		
		# Set next story
		story_number += 1
		GameManager.set_story(story_number)
		reset_environment()
	else:
		get_node("/root/Adventure/HUD").show_dialogues([default_dialogue])

# Synchronise custom player name with game story dialogues
func syncro_names() -> void:
	stories_reference = parse_json(to_json(stories_reference).replace("Naru", GameManager.get_player_name()[1]))

# Reset current map environment to support game story
func reset_environment() -> void:
	story_number = GameManager.get_story()
	
	var map = get_node("/root/Adventure/Map").get_child(0)
	match map.get_name():
		"InitialMap":
			var teller_mathea = map.get_node("NPCs/Mathea/StoryArea")
			match story_number:
				1:
					teller_mathea.story_number = story_number
					teller_mathea.auto_narrate = true
				2:
					teller_mathea.story_number = story_number
					teller_mathea.auto_narrate = false
				_:
					teller_mathea.default_dialogue = "Semoga beruntung!"