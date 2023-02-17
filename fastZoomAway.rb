
# FastZoomAway - Fast navigation around large objects.
# A plugin for Sketchup that allows you to quickly zoom out of a current view.

# This plugin is designed to help Sketchup users work more efficiently on large models by allowing them to 
# on large models by allowing them to quickly zoom out of their current view 
# to refocus on another point on the model without having to scroll the mouse wheel 
# or using the zoom tool. For example, when you need to work on a lot of sides of a large room.

# To use FastZoomAway, it is advisable to use a keyboard shortcut of your choice. 

# When the keyboard shortcut is used, the plugin quickly zooms out the current view and refocuses the view on another point of the model.

# This version is set to work correctly with the metre as the unit.

# FastZoomAway - Navigation rapide autour des grands objets.
# Un plugin pour Sketchup qui permet de dézoomer rapidement d'une vue actuelle.

# Ce plugin est conçu pour aider les utilisateurs de Sketchup à travailler plus efficacement 
# sur des modèles de grande taille en leur permettant de dézoomer rapidement de leur vue actuelle 
# pour se recentrer sur un autre point du modèle sans avoir à faire défiler la roulette de la souris 
# ou à utiliser l'outil de zoom. Par exemple, quand on doit travailler sur beaucoup d'aretes d'une grande pièce.

# Pour utiliser FastZoomAway, il est conseillé d'y associer un raccourci clavier au choix. 

# Lorsque le raccourci clavier est utilisé, le plugin dézoome rapidement la vue actuelle et recentre la vue sur un autre point du modèle.

# Cette version est réglée pour marcher correctement avec le metre comme unité.



# require 'sketchup.rb'
require 'extensions.rb'

# C:/Users/d/AppData/Roaming/SketchUp
# C:/Users/d/AppData/Roaming/SketchUp/SketchUp 2021/SketchUp/Plugins/

# https://ruby.sketchup.com/top-level-namespace.html
# https://ruby.sketchup.com/Sketchup/Camera.html
#     load 'C:\SketchupPRO-2020\plugin\fastZoomAway.rb'
# view = Sketchup.active_model.active_view;camera = view.camera;eye = camera.eye;target= camera.target
# Sketchup.active_model.active_view.camera.fov
#   eye = [1000,1000,1000]; target = [0,0,0]; up = [0,0,1]; my_camera = Sketchup::Camera.new eye, target, up; view = Sketchup.active_model.active_view; view.camera = my_camera

module FastZoomAway
  @@last_call_time = Time.now
  UNZOOM_FACTOR = 1.05
  UNZOOMPOWER_INIT = 500
  UNZOOMPOWER_MAX = 10000

  def self.fastZoomAway
    # SKETCHUP_CONSOLE.show
    # SKETCHUP_CONSOLE.clear

    current_time = Time.now
    elapsed_time = current_time - @@last_call_time
    @@last_call_time = current_time

    @@unZoomPower ||= UNZOOMPOWER_INIT # Initialise statique variable if not yet.
    if elapsed_time > 0.4 then
      @@unZoomPower = UNZOOMPOWER_INIT
    end

    view = Sketchup.active_model.active_view
    camera = view.camera
  
    ex = camera.eye.x - ( @@unZoomPower * camera.direction.x )
    ey = camera.eye.y - ( @@unZoomPower * camera.direction.y )
    ez = camera.eye.z - ( @@unZoomPower * camera.direction.z )
    eye = [ ex, ey, ez ]

    view.camera.set(eye, view.camera.target, view.camera.up)

    @@unZoomPower *= UNZOOM_FACTOR
    if @@unZoomPower > UNZOOMPOWER_MAX then 
      @@unZoomPower = UNZOOMPOWER_MAX
    end

    Sketchup.send_action("selectZoomWindowTool:") # Select next tool

  end

  # # This adds an item to the Camera menu to activate our custom animation.
  # UI.menu("Camera").add_item("Run Float Up Animation") {
  #   Sketchup.active_model.active_view.animation = FloatUpAnimation.new
  # }

  unless file_loaded?(__FILE__)
    menu = UI.menu("Plugins")
    menu.add_item("FastZoomAway") { self.fastZoomAway }
    file_loaded(__FILE__)
  end
 
end
 

