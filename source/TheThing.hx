package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class TheThing extends MusicBeatState
{
	public var bg:FlxSprite;

	override function create()
	{
		super.create();
		bg = new FlxSprite().loadGraphic(Paths.image('ausvsete2', 'eteled'));
		add(bg);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}
	}
}
