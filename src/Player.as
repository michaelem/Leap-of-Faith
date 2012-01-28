package
{
	import org.flixel.*;
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/player_idle.png")] private static var ImgIdle:Class;
		
		private var mayJump:Boolean;
		
		public function Player(X:Number, Y:Number):void
		{
			super(X, Y, ImgIdle);
			maxVelocity.x = 180;
			maxVelocity.y = 400;
			acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
			mayJump = true;
		}
		
		public function touched(object:FlxObject, player:FlxObject): void
		{
            if (player.isTouching(FlxObject.FLOOR)) {
                player.flicker();
            }
		}
		
		override public function update():void
		{
			// MOVEMENT
			acceleration.x = 0;
			if (FlxG.keys.LEFT) {
				acceleration.x = -maxVelocity.x*4;
			} else if (FlxG.keys.RIGHT) {
				acceleration.x = maxVelocity.x*4;
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
