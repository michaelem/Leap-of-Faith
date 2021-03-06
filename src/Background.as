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
		
		override public function setCameras(CAMERAS:Array):void
		{
			camera = CAMERAS[0];
			super.setCameras(CAMERAS);
		}
		
		override public function update():void
		{
			super.update();
			var i_scroll:int = Math.floor(scroll);
			var id:int = scroll / bg1.height;
			var offset:int = scroll % bg1.height;
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

