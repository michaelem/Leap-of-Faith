package
{
	import org.flixel.*;
	public class Clouds extends FlxGroup
	{
		[Embed(source="../assets/clouds.png")] private static var ImgClouds:Class;
		
		private var camera:FlxCamera;
		private var img1:FlxSprite;
		private var img2:FlxSprite;
		private var img3:FlxSprite;
		private var img4:FlxSprite;
		
		private var xOffset1:Number;
		private var xOffset2:Number;
		private var yOffset:Number;
		
		public function Clouds():void
		{
			img1 = new FlxSprite(0, 0, ImgClouds);
			img2 = new FlxSprite(0, 0, ImgClouds);
			img3 = new FlxSprite(0, 0, ImgClouds);
			img4 = new FlxSprite(0, 0, ImgClouds);
			add(img1);
			add(img2);
			add(img3);
			add(img4);
			yOffset = 0;
			xOffset1 = xOffset2 = 0;
		}
		
		override public function setCameras(CAMERAS:Array):void
		{
			super.setCameras(CAMERAS);
			camera = CAMERAS[0];
		}
		
		override public function update():void
		{
			super.update();
			xOffset1 += 29 * FlxG.elapsed;
			if (xOffset1 > img1.width) xOffset1 -= img1.width;
			xOffset2 += 37 * FlxG.elapsed;
			if (xOffset2 > img3.width) xOffset2 -= img3.width;
			img1.x = -xOffset1;
			img2.x = img1.x + img1.width;
			img3.x = xOffset2;
			img4.x = img3.x - img4.width;
			yOffset += 2 * FlxG.elapsed;
		}
		
		override public function draw():void
		{
			img1.y = img2.y = -10 + 10 * Math.sin(yOffset) + camera.scroll.y;
			img3.y = img4.y = -10 + 10 * Math.sin(yOffset*0.77) + camera.scroll.y;
			img1.draw();
			img2.draw();
			img3.draw();
			img4.draw();
		}
	}
}
