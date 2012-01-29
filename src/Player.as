package
{
	import org.flixel.*;
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/player_sprite.png")] private static var imgPlayer:Class;
		[Embed(source="../assets/blood_emitter.png")] private static var imgBlood:Class;
		//[Embed(source="../assets/Jump70.mp3")] private static var SndJump:Class;
		
		private var mayJump:Boolean;
		public var pain:Boolean;
		private var painCounter:Number;
		private var painEmitter:FlxEmitter;
		private var jumpgo:Boolean;
		
		public function Player(X:Number, Y:Number):void
		{
			super(X, Y);
			maxVelocity.x = 180;
			maxVelocity.y = 400;
			acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
			mayJump = true;
			loadGraphic(imgPlayer, true, true, 24, 50);
			offset = new FlxPoint(4, 6);
			width = 16;
			height = 40;
			addAnimation("run", new Array(1,2,3,4,5,6), 10, true);
			addAnimation("jumpgo", new Array(7,7), 20, false);
			addAnimation("jump", new Array(8,9), 10, true);
			addAnimation("pain", new Array(10,11), 10, true);
			addAnimation("idle", new Array(0,0), 1, true);
			painCounter = 0;
			jumpgo = false;
			
			painEmitter = new FlxEmitter();
			painEmitter.makeParticles(imgBlood, 50, 16, true, 0);
			painEmitter.setRotation(0, 360);
			painEmitter.setYSpeed(-50, 100);
			painEmitter.setXSpeed(-100, 100);
			painEmitter.gravity = 100;
			
			resetPain();
		}
		
		public function isDead():Boolean
		{
			return (painCounter > 2.0);
		}
		
		public function resetPain():void
		{
			painCounter = 0;
			pain = false;
			acceleration.y = 700;
			painEmitter.on = false;
		}
		
		override public function update():void
		{
			painEmitter.x = x + 8;
			painEmitter.y = y + 10;
			if (pain) {
				acceleration.x = 0;
				x += Math.random() * 6 - 3;
				y += Math.random() * 2 - 1;
				painCounter += FlxG.elapsed;
				if (!painEmitter.on) {
					painEmitter.start(false, 0, 0.01, 0);
				}
				painEmitter.update();
				play("pain");
				return;
			}
			// MOVEMENT
			acceleration.x = 0;

			if (FlxG.keys.LEFT) {
				acceleration.x = -maxVelocity.x*4;
				facing = FlxObject.RIGHT;
			} else if (FlxG.keys.RIGHT) {
				acceleration.x = maxVelocity.x*4;
				facing = FlxObject.LEFT;
			}
			
			if (isTouching(FlxObject.FLOOR) && !jumpgo) {	
				if (FlxG.keys.LEFT || FlxG.keys.RIGHT) {
					play("run");
				} else {
					play("idle");
				}
			}
			if(FlxG.keys.justReleased("SPACE")) {
				mayJump = true;
			}
			if (jumpgo && finished) {
				velocity.y = -maxVelocity.y;
				jumpgo = false;
				play("jump");
			} else if(FlxG.keys.SPACE && mayJump && isTouching(FlxObject.FLOOR)) {
				//FlxG.play(SndJump);
				mayJump = false;
				jumpgo = true;
				play("jumpgo");
			}
			painEmitter.update();
		}
		
		override public function draw():void
		{
			super.draw();
			painEmitter.setCameras(this.cameras);
			painEmitter.draw();
		}
	}
}
