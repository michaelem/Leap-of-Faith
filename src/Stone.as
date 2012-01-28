package
{
	import org.flixel.*;
	public class Stone extends FlxSprite
	{
		[Embed(source="../assets/tiles_cardboard.png")] private static var imgStones:Class;
		
		
		public function Stone(X:Number, Y:Number):void
		{
			super(X, Y, imgStones);
			maxVelocity.x = 180;
			maxVelocity.y = 400;
			acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
			loadGraphic(imgStones, true, true, 35, 35);
			addAnimation("fall", new Array(6,6,6), 3, true);
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			play("fall");
		}
	}
}
