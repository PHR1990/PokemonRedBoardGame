extends Node


func change_color(fileName):
	
	var imageFile : Image = Image.new()
	
	imageFile.load(fileName)
	
	imageFile.lock()
	
	var mat : Dictionary = {}
	
	
	for row in range(0, imageFile.get_size().x):
		for col in range(0,imageFile.get_size().y):
			
			mat[imageFile.get_pixel(row, col)] = "color"
	
	var newColors = [
		Color.aliceblue, 
		Color.antiquewhite, 
		Color.aqua, 
		Color.azure, 
		Color.beige, 
		Color.blanchedalmond, 
		Color.bisque
		]
	var counter = 0;
	
	for key in mat.keys():
		mat[key] = newColors[counter]
		counter+=1
	
	imageFile.lock()
	for row in range(0, imageFile.get_size().x):
		for col in range(0,imageFile.get_size().y):
			
			imageFile.set_pixel(row,col, mat[imageFile.get_pixel(row, col)])
	imageFile.unlock()
	imageFile.lock()
	imageFile.save_png("res://Assets/CardTemplates/generatedbackground.png")
	imageFile.unlock()
	return imageFile
