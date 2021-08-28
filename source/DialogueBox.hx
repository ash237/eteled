package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.system.FlxSound;
using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var fulldialogueList:Array<String> = [];
	var fullSoundList:Array<String> = [];
	var characterList:Array<String> = [];
	var rawDialogue:Array<String> = [];
	var curDialogue:Int = 0;
	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var coolDialogue:FlxTypeText;
	var cutscene:FlxSprite;
	var dropText:FlxText;

	public var finishThing:Void->Void;

	public var doTheCutscene:Void->Void;
	public var destroyRed:Void->Void;

	public var fuckyouImadethislikeanhourbeforerelease:Void->Void;
	
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var switchingScene:Bool = false;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var specialblack:FlxSprite;

	var folderPrefix:String = '';

	var charLabel:FlxSprite;

	var dialogueSound:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>, ?startingCutscene:String = '1')
	{
		super();
		dialogueSound = new FlxSound();
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'dream-of-peace':
				FlxG.sound.playMusic(Paths.music('Eteled_Cutscene_2_2', 'eteled'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.1);
			case 'diagraphephobia':
				
				FlxG.sound.playMusic(Paths.music('Eteled_Cutscene_3_1', 'eteled'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.1);
			case 'post-mortal':
				FlxG.sound.playMusic(Paths.music('Eteled_Cutscene_2_2', 'eteled'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.1);
		}
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		specialblack = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		specialblack.scrollFactor.set();
		switch (PlayState.SONG.song.toLowerCase()) {
			default:
				new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					bgFade.alpha += (1 / 10) * 0.7;
					if (bgFade.alpha > 0.7)
						bgFade.alpha = 0.7;
				}, 10);
			/*case 'dream-of-peace':
				add(specialblack);
				cutscene = new FlxSprite().loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + startingCutscene, 'eteled'));
				cutscene.scrollFactor.set();
				add(cutscene);
				cutscene.alpha = 0;
				FlxTween.tween(cutscene, {alpha: 1}, 0.2, {
					startDelay: 0.1
				});*/
		}
		cutscene = new FlxSprite();
		cutscene.alpha = 0;
		charLabel = new FlxSprite(-30, 438).loadGraphic(Paths.image('labels/austin', 'eteled'));
		charLabel = new FlxSprite(-25, 435).loadGraphic(Paths.image('labels/eteled', 'eteled'));
		charLabel = new FlxSprite(-30, 444).loadGraphic(Paths.image('labels/bf', 'eteled'));
		charLabel = new FlxSprite(-30, 444).loadGraphic(Paths.image('labels/gf', 'eteled'));
		charLabel.alpha = 0;
		
		switch (PlayState.SONG.song.toLowerCase()) {
		}

		box = new FlxSprite(-35, 470);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				hasDialog = true;
				//box.loadGraphic(Paths.image('miibox', 'eteled'));
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'eteled');
				//box.y += 320;
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
		}

		rawDialogue = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'challenger' | 'ouch' | 'ego' | 'frenzy' | 'vibe' | 'orbit' | 'genesis' | 'golden' | 'vast':
				portraitRight = new FlxSprite(0, 40);
				portraitLeft = new FlxSprite(-60, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
			default:
				portraitRight = new FlxSprite(0, 40);
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				//box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		
		
		
		add(portraitLeft);
		portraitLeft.visible = false;
		
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');


		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		//add(handSelect);

		if (!talkingRight)
		{
			box.flipX = true;
		}
		add(charLabel);
		
		swagDialogue = new FlxTypeText(51, 570, 1192, "", 37);
		swagDialogue.font = Paths.font('A-OTF-ShinGoPro-DeBold.otf');
		swagDialogue.color = 0xFFFFFFFF;
		//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		swagDialogue.setBorderStyle(OUTLINE, FlxColor.fromString('#FF304845'), 7, 7);
		add(swagDialogue);
		
		coolDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		coolDialogue.font = 'Pixel Arial 11 Bold';
		coolDialogue.color = 0xFF3F2021;
		//coolDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		dialogue = new Alphabet(0, 80, "", false, true);
		cleanDialog();
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			//dropText.color = FlxColor.BLACK;
		}

		//dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
	
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);
			if (!switchingScene)
				addDialogue();
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		if (dialogueSound.playing)
			dialogueSound.stop();
		if (fullSoundList[curDialogue] != '') {
			dialogueSound = FlxG.sound.play(Paths.sound(fullSoundList[curDialogue], 'eteled'), 1);
			dialogueSound.play();
		}
		trace(fullSoundList[curDialogue]);
		box.alpha = 1;
		var boxType:Int = 0;
		var labelType:Int = 0;
		switch (characterList[curDialogue])
		{
			case 'np-austin':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				boxType = 1;
				labelType = 2;
			case 'np-gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				labelType = 3;
			case 'np-eteled':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				boxType = 1;
				labelType = 1;
			case 'np-bf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
			case 'np-mystery':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				boxType = 1;
				labelType = 5;
			case 'none':
				portraitLeft.visible = false;
				portraitRight.visible = false;
			case 'mystery1':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(29, 162).loadGraphic(Paths.image('portraits/austin1', 'eteled'));
				add(portraitLeft);
				labelType = 5;
				boxType = 1;
			case 'mystery2':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(29, 162).loadGraphic(Paths.image('portraits/austin2', 'eteled'));
				add(portraitLeft);
				labelType = 5;
				boxType = 1;
			case 'austin1':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(29, 162).loadGraphic(Paths.image('portraits/austin1', 'eteled'));
				add(portraitLeft);
				labelType = 2;
				boxType = 1;
			case 'austin2':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(22, 149).loadGraphic(Paths.image('portraits/austin2', 'eteled'));
				add(portraitLeft);
				labelType = 2;
				boxType = 1;
			case 'austin3':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(0, 149).loadGraphic(Paths.image('portraits/austin3', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 2;
			case 'austin4':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(2, 164).loadGraphic(Paths.image('portraits/austin4', 'eteled'));
				add(portraitLeft);
				labelType = 2;
				boxType = 1;
			case 'austin5':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(22, 148).loadGraphic(Paths.image('portraits/austin5', 'eteled'));
				add(portraitLeft);
				labelType = 2;
				boxType = 1;

			case 'eteled1':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(84, 211).loadGraphic(Paths.image('portraits/eteled1', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled2':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(98, 235).loadGraphic(Paths.image('portraits/eteled2', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled3':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(74, 214).loadGraphic(Paths.image('portraits/eteled3', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled4':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(74, 215).loadGraphic(Paths.image('portraits/eteled4', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled5':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(84, 219).loadGraphic(Paths.image('portraits/eteled5', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled6':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(98, 282).loadGraphic(Paths.image('portraits/eteled6', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled7':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(98, 297).loadGraphic(Paths.image('portraits/eteled7', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'eteled8':
				portraitLeft.visible = true;
				portraitRight.visible = false;
				box.flipX = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(58, 275).loadGraphic(Paths.image('portraits/eteled8', 'eteled'));
				add(portraitLeft);
				boxType = 1;
				labelType = 1;
			case 'bf':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				
				box.flipX = false;
				remove(portraitRight);	
				portraitRight = new FlxSprite(17, 274).loadGraphic(Paths.image('portraits/bf', 'eteled'));
				portraitRight.flipX = true;
				add(portraitRight);
			case 'gf':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				box.flipX = false;
				remove(portraitRight);
				portraitRight = new FlxSprite(894, 254).loadGraphic(Paths.image('portraits/gf', 'eteled'));
				add(portraitRight);
				labelType = 3;
		}
		
		switch (boxType) {
			case 0:
				remove(box);
				box = new FlxSprite(-20, 433);
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking2', 'eteled');
				box.animation.addByIndices('normal', 'samkyle speech bubble normal', [11], "", 24);
				box.animation.play('normal');
				box.updateHitbox();
				//box.screenCenter(X);
				trace(box.x);
				swagDialogue.y = 570;
				swagDialogue.borderColor = FlxColor.fromString("#FF000000");
				add(box);
				addLabel(labelType);
			case 1:
				remove(box);
				box = new FlxSprite(-35, 470);
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'eteled');
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
				box.animation.play('normal');
				box.updateHitbox();
				box.screenCenter(X);
				swagDialogue.y = 550;
				swagDialogue.borderColor = FlxColor.fromString("#FF304845");
				add(box);
				addLabel(labelType);
		}
		
		swagDialogue.alpha = 1;
		swagDialogue.resetText(fulldialogueList[curDialogue]);
		swagDialogue.start(0.04, true);
	}
	function addLabel(labelType:Int) {
		switch (labelType) {
			case 0:
				remove(charLabel);
				charLabel = new FlxSprite(-30, 444).loadGraphic(Paths.image('labels/bf', 'eteled'));
				add(charLabel);
			case 1:
				remove(charLabel);
				charLabel = new FlxSprite(-25, 435).loadGraphic(Paths.image('labels/eteled', 'eteled'));
				add(charLabel);
			case 2:
				remove(charLabel);
				charLabel = new FlxSprite(-30, 438).loadGraphic(Paths.image('labels/austin', 'eteled'));
				add(charLabel);
			case 3:
				remove(charLabel);
				charLabel = new FlxSprite(-30, 444).loadGraphic(Paths.image('labels/gf', 'eteled'));
				add(charLabel);
			case 5:
				remove(charLabel);
				charLabel = new FlxSprite(-30, 444).loadGraphic(Paths.image('labels/fuck', 'eteled'));
				add(charLabel);
		}
	}
	function cleanDialog():Void
	{
		for (i in 0...rawDialogue.length) {
			var splitName:Array<String> = rawDialogue[i].split(":");
			characterList.push(splitName[0]);
			fulldialogueList.push(splitName[1]);
			fullSoundList.push(splitName[2]);
		}
	}
	function addDialogue():Void {
		if (curDialogue == fulldialogueList.length - 1)
		{
			if (!isEnding)
			{
				if (dialogueSound.playing)
					dialogueSound.stop();
				isEnding = true;
				

				FlxG.sound.music.fadeOut(1.2, 0);

				new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					
					box.alpha -= 1 / 10;
					bgFade.alpha -= 1 / 10;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					swagDialogue.alpha -= 1 / 10;
					cutscene.alpha -= 1/10;
					if (specialblack.alpha > 0)
						specialblack.alpha -= 1/10;
					charLabel.alpha -= 1/10;
				}, 10);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
		}
		else
		{
			
			curDialogue++;
			
			if (characterList[curDialogue] == 'switch') {
				switchCutscene(Std.parseInt(fulldialogueList[curDialogue]));
			} else if (characterList[curDialogue] == 'switchnoboc') {
				switchCutsceneNoBox(Std.parseInt(fulldialogueList[curDialogue]));
			}else if (characterList[curDialogue] == 'fuck') {
				cutscene = new FlxSprite();
				add(cutscene);
			}else if (characterList[curDialogue] == 'nobg') {
				switchToGame();
			} else if (characterList[curDialogue] == 'start') {
				startUsingCutscenes(Std.parseInt(fulldialogueList[curDialogue]));
			} else if (characterList[curDialogue] == 'credits') {
				switchingScene = true;
				LoadingState.loadAndSwitchState(new VideoState2("assets/videos/outrofinaleteled.webm", function() {
					FlxG.switchState(new TheThing());
				}));
			} else if (characterList[curDialogue] == 'wait') {
				new FlxTimer().start(Std.parseFloat(fulldialogueList[curDialogue]), function(tmr:FlxTimer)
				{
					addDialogue();
				});
			} else if (characterList[curDialogue] == 'music') {
				FlxG.sound.music.fadeOut(0.3, 0, function (twn:FlxTween) {
					FlxG.sound.playMusic(Paths.music(fulldialogueList[curDialogue], 'eteled'), 0);
					FlxG.sound.music.fadeIn(0.3, 0, 0.1);
					addDialogue();
				});
				
			} else {
				startDialogue();
			}
		}
	}
	function startNeedle() {
		switchingScene = true;
		remove(portraitLeft);
		remove(portraitRight);
		remove(box);
		remove(swagDialogue);
		remove(dialogue);
		//remove(dropText);
		remove(bgFade);
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxTween.tween(specialblack, {alpha: 0}, 1, {
				onComplete: function(tween:FlxTween)
				{
					doTheCutscene();
				}
			});
		});
	}
	public function continueDialogue() {
		switchingScene = false;
		box.alpha = 1;
		swagDialogue.alpha = 1;
		swagDialogue.visible = true;
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		dialogue.alpha = 1;
		add(dialogue);
		add(portraitLeft);
		add(portraitRight);
		add(box);
		add(swagDialogue);	
		addDialogue();
	}
	function switchToGame():Void {
		FlxG.sound.music.fadeOut(1, 0);
		switchingScene = true;
		remove(portraitLeft);
		remove(portraitRight);
		remove(box);
		remove(swagDialogue);
		remove(dialogue);
		//remove(dropText);
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxTween.tween(cutscene, {alpha: 0}, 1, {
				onComplete: function(tween:FlxTween)
				{
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
							addDialogue();
							switchingScene = false;
							box.alpha = 1;
							dialogue.alpha = 1;
							add(dialogue);
							add(portraitLeft);
							add(portraitRight);
							add(box);
							add(swagDialogue);	
					});
				}
			});
			FlxTween.tween(specialblack, {alpha: 0}, 1, {});
		});
	}

	function startUsingCutscenes(scene:Int):Void {
		switchingScene = true;
		remove(portraitLeft);
		remove(portraitRight);
		remove(box);
		remove(swagDialogue);
		remove(dialogue);
		remove(charLabel);
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			
			cutscene = new FlxSprite(0, 0).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + Std.string(scene), 'eteled'));
			cutscene.scrollFactor.set();
			cutscene.alpha = 0;	
			swagDialogue.resetText(fulldialogueList[curDialogue]);
			portraitLeft.visible = false;
			portraitRight.visible = false;
			specialblack.alpha = 0;
			add(specialblack);
			add(cutscene);
			FlxTween.tween(cutscene, {alpha: 1}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					specialblack.alpha = 1;
					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
						addDialogue();
					});
					switchingScene = false;
					box.alpha = 1;
					/*swagDialogue.alpha = 1;
					swagDialogue.visible = true;
					swagDialogue.font = 'Pixel Arial 11 Bold';
					swagDialogue.color = 0xFF3F2021;
					dropText.alpha = 1;
					dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
					dropText.font = 'Pixel Arial 11 Bold';
					dropText.color = 0xFFD89494;
					dropText.alpha = 1;
					dialogue.alpha = 1;*/
						
					add(dialogue);
					add(portraitLeft);
					add(portraitRight);
					add(box);
					//add(dropText);
					add(charLabel);
					add(swagDialogue);	
					
				}
			});
		});
	}

	function switchCutsceneNoBox(scene:Int):Void {
		
		switchingScene = true;
		portraitLeft.visible = false;
		portraitRight.visible = false;
		box.visible = false;
		swagDialogue.visible = false;
		dialogue.visible = false;
		charLabel.visible = false;
		//remove(dropText);
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(cutscene, {alpha: 0.5}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					remove(cutscene);
					cutscene = new FlxSprite(0, 0).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + Std.string(scene), 'eteled'));
					cutscene.scrollFactor.set();
					cutscene.alpha = 0.5;	
					swagDialogue.resetText(fulldialogueList[curDialogue]);
					add(cutscene);
					/*new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{*/
						FlxTween.tween(cutscene, {alpha: 1}, 0.2, {
							onComplete: function(tween:FlxTween)
							{
								new FlxTimer().start(0.05, function(tmr:FlxTimer)
								{
									addDialogue();
								});
								switchingScene = false;
							}
						});
					//});
				}
			});
		});
	}

	function switchCutscene(scene:Int):Void {
		switchingScene = true;
		remove(portraitLeft);
		remove(portraitRight);
		remove(box);
		remove(swagDialogue);
		remove(dialogue);
		remove(charLabel);
		//remove(dropText);
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(cutscene, {alpha: 0.5}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					remove(cutscene);
					cutscene = new FlxSprite(0, 0).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + Std.string(scene), 'eteled'));
					cutscene.scrollFactor.set();
					cutscene.alpha = 0.5;	
					swagDialogue.resetText(fulldialogueList[curDialogue]);
					portraitLeft.visible = false;
					portraitRight.visible = false;
					add(cutscene);
					/*new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{*/
						FlxTween.tween(cutscene, {alpha: 1}, 0.2, {
							onComplete: function(tween:FlxTween)
							{
								new FlxTimer().start(0.05, function(tmr:FlxTimer)
								{
									addDialogue();
								});
								switchingScene = false;
								box.alpha = 1;
								portraitLeft.visible = false;
								portraitRight.visible = false;
								box.visible = true;
								swagDialogue.visible = true;
								dialogue.visible = true;
								charLabel.visible = true;
								add(dialogue);
								add(portraitLeft);
								add(portraitRight);
								add(box);
								add(charLabel);
								//add(dropText);
								add(swagDialogue);	
							}
						});
					//});
				}
			});
		});
	}
}
