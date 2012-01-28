	package
{
	import org.flixel.*;
	
	public class IngameState extends FlxState
	{
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		[Embed(source="../assets/tiles.png")] private static var ImgTiles:Class;
		
		private static const WIDTH:uint = 440;
		private static const HEIGHT:uint = 450;
		
		private var gameCamera:FlxCamera;
		private var border:FlxSprite;
		private var level:FlxTilemap;
		private var player:FlxSprite;
		
		override public function create():void
		{	
			gameCamera = new FlxCamera(30, 30, WIDTH, HEIGHT);
			
			FlxG.addCamera(gameCamera);
			FlxG.bgColor = 0xffaaaaaa;
			
			
			level = new FlxTilemap();
			var data:Array = new Array(
				1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
				0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
				0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
				1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1 );
			level.loadMap(FlxTilemap.arrayToCSV(data,12), ImgTiles, 35, 35, FlxTilemap.AUTO);
			level.cameras = new Array(FlxG.cameras[1]);
			add(level);
			
			player = new FlxSprite(FlxG.width/2 - 9, 0);
			player.makeGraphic(18, 45, 0xffff0000);
			player.maxVelocity.x = 180;
			player.maxVelocity.y = 400;
			player.acceleration.y = 700;
			player.drag.x = player.maxVelocity.x * 4;
			player.cameras = new Array(FlxG.cameras[1]);
			add(player);
			
			border = new FlxSprite(0, 0, ImgBorder);
			border.cameras = new Array(FlxG.cameras[0]);
			add(border);
			
			FlxG.cameras[1].setBounds(0, 0, WIDTH, HEIGHT*2)
			cameraflow();	
		}
		
		override public function update():void
		{
			// MOVEMENT
			player.acceleration.x = 0;
			if (FlxG.keys.LEFT) {
				player.acceleration.x = -player.maxVelocity.x*4;
			} else if (FlxG.keys.RIGHT) {
				player.acceleration.x = player.maxVelocity.x*4;
			}
			if(FlxG.keys.justPressed("SPACE") && player.isTouching(FlxObject.FLOOR)) {
				player.velocity.y = -player.maxVelocity.y;
			}
			super.update();
			// IF FALLING DOWN, OUTSIDE THE SCREEN
			if (player.y > FlxG.height*2) {
				//player.y = player.y - HEIGHT*2;
			}
			
			// COLLISION
			FlxG.collide(level,player);
			
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		public function cameraflow():void
		{
			//FlxG.cameras[1].setBounds(0, 0, WIDTH, HEIGHT*2)
			FlxG.cameras[1].follow(player, 2)
		}
	}
}
