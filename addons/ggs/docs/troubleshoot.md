## Can't use the plugin after installation
When you first install the plugin, Godot might output the following error:
```
Parse Error: Identifier "GGS" not declared in the current scope.
```
This means that the GGS singleton doesn't exist. When the plugin is first added, Godot tries to parse its scripts and since the singleton doesn't exist at that point (since the plugin is not enabled yet), it'll throw that error. The plugin will not function properly even after you add the singleton to the project. To fix it:
1. Make sure the singleton is added to the autoload list (Project Settings → Autoload) and it's enabled.
2. Reload the project.

Note that the plugin adds the singleton automatically when enabled. If for some reason it doesn't, you can find the script at the following path:
```
res://addons/ggs/classes/ggs_globals.gd
```
Simply add that script to the autoload list, **name it GGS**, and reload the project.


## Setting type error
```
Invalid type in function 'apply' in base 'Resource ()'. Cannot convert argument 1 from <somet_type> to <some_other_type>.
```
When launching the game, you may encounter the above error, which leads to `ggs_globals.gd`. If so, check your setting scripts. Make sure the type the `apply()` method receives is correct. For example, your `apply()` method might expect a `bool` value but it's receiving a `String`.
