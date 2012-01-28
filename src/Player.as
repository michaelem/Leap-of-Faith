package
{
	import org.flixel.*;
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/player_idle.png")] private static var ImgIdle:Class;
		public function Player(X:Number, Y:Number):void
		{
			super(X, Y, ImgIdle);
			maxVelocity.x = 180;
			maxVelocity.y = 400;
			acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
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
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR)) {
				velocity.y = -maxVelocity.y;
			}
		}
	}
}
