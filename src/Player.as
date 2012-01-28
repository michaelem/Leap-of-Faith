package
{
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/player_sprite.png")] private static var imgPlayer:Class;
		
		private var mayJump:Boolean;
		
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
			addAnimation("runRight", new Array(1,2,3,4,5,6,7), 10, true);
			addAnimation("runLeft", new Array(1,2,3,4,5,6,7), 10, true);
			addAnimation("idle", new Array(0), 1, true);
		}
		
		public function touched(object:FlxObject, player:FlxObject): void
		{
            if (player.isTouching(FlxObject.FLOOR)) {
                //player.flicker();
                FlxG.log(object);
                /*
                if (object.index == 4) {
                    player.flicker();
                } else {
                    player.flicker();
                }*/
                
            }
		}
		
		override public function update():void
		{
			// MOVEMENT
			acceleration.x = 0;
			if (FlxG.keys.LEFT) {
				acceleration.x = -maxVelocity.x*4;
				facing = FlxObject.RIGHT;
				play("runLeft");
			} else if (FlxG.keys.RIGHT) {
				acceleration.x = maxVelocity.x*4;
				facing = FlxObject.LEFT;
				play("runRight");
			} else {
				play("idle");
			}
			if(FlxG.keys.justReleased("SPACE")) {
				mayJump = true;
			}
			if(FlxG.keys.SPACE && mayJump && isTouching(FlxObject.FLOOR)) {
				velocity.y = -maxVelocity.y;
				mayJump = false;
			}
		}
	}
}
