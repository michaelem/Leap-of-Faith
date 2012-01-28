package
{
	import org.flixel.*;
	public class Camera extends FlxObject
	{
		private var flxCamera:FlxCamera;
		private var player:Player;
		
		public function Camera(CAMERA:FlxCamera, PLAYER:Player):void
		{
			this.flxCamera = CAMERA;
			this.player = PLAYER;
			maxVelocity.y = 100;
		}
		
		override public function update():void
		{
			this.y = flxCamera.scroll.y;
			if (y + 150 > player.y) {
				acceleration.y = -100;
				drag.y = 0;
			} else {
				acceleration.y = 0;
				drag.y = 1000;
			}
			velocity.y += acceleration.y * FlxG.elapsed;
			if (velocity.y > maxVelocity.y) velocity.y = maxVelocity.y;
			if (velocity.y < -maxVelocity.y) velocity.y = -maxVelocity.y;
			if (velocity.y > 0) {
				velocity.y -= drag.y * FlxG.elapsed;
				if (velocity.y < 0) velocity.y = 0;
			} else {
				velocity.y += drag.y * FlxG.elapsed;
				if (velocity.y > 0) velocity.y = 0;
			}
			y += velocity.y * FlxG.elapsed;
			flxCamera.scroll.y = y;
			flxCamera.update();
		}
	}
}
