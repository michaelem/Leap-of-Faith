package
{
	import org.flixel.*;
	public class Background extends FlxGroup
	{
		[Embed(source="../assets/background.png")] private static var ImgBackground:Class;
		
		private var bg1:FlxSprite;
		private var bg2:FlxSprite;
		
		public var scroll:Number;
		
		private var camera:FlxCamera;
		
		public function Background(CAMERAS:Array):void
		{
			bg1 = new FlxSprite(0, 0, ImgBackground);
			bg2 = new FlxSprite(0, 0, ImgBackground);
			add(bg1);
			add(bg2);
			scroll = 0;
			setCameras(CAMERAS);
			update();
		}
		
		public function setCameras(cameras:Array):void
		{
			bg1.cameras = cameras;
			bg2.cameras = cameras;
			camera = cameras[0];
		}
		
		override public function update():void
		{
			super.update();
			var id:int = Math.floor(scroll / bg1.height);
			var offset:Number = scroll - id * bg1.height;
			if (id%2 == 0) {
				bg1.y = offset + camera.scroll.y;
				bg2.y = offset - bg2.height + camera.scroll.y;
			} else {
				bg2.y = offset + camera.scroll.y;
				bg1.y = offset - bg1.height + camera.scroll.y;
			}
		}
	}
}

