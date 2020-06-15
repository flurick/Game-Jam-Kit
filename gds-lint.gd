tool
extends EditorScript


func _run():
	get_filelist("res://")


var file = File.new()
func lint(script):
	
	file.open(script, File.READ)
	
	var line_nr = 1
	var line = file.get_line()
	var warnings = []
	while line:
		
		testappend(line.find("$.."), warnings,line)
		testappend(line.find("get_node(.."), warnings,line)
		testappend(line.find("get_parent()"), warnings,line)
		
		line = file.get_line()
		line_nr+=1
	
	file.close()
	
	print(script,":",warnings)


func testappend(test, target, context=""):
	if test>0: target.append([test,context])


func get_filelist(scan_dir : String) -> Array:
	var my_files : Array = []
	var dir := Directory.new()
	if dir.open(scan_dir) != OK:
		printerr("Warning: could not open directory: ", scan_dir)
		return []
	
	if dir.list_dir_begin(true, true) != OK:
		printerr("Warning: could not list contents of: ", scan_dir)
		return []
	
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			my_files += get_filelist(dir.get_current_dir() + "/" + file_name)
		else:
			if file_name.ends_with(".gd"):
				lint(dir.get_current_dir() + "/" + file_name)
				my_files.append(dir.get_current_dir() + "/" + file_name)
	
		file_name = dir.get_next()
	
	return my_files


