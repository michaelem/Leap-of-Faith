	package
{
	import org.flixel.*;
	
	public class IngameState extends FlxState
	{
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		[Embed(source="../assets/tiles.png")] private static var ImgTiles:Class;
		[Embed(source="../assets/aaaiight.ttf", fontFamily="aaaiight", embedAsCFF="false")] private	var	aaaiightFont:String;
		
		private static const WIDTH:uint = 440;
		private static const HEIGHT:uint = 450;
		
		private static const TILESIZE:uint = 35;
		private static const TM_WIDTH:uint = TILESIZE * 13;
		private static const TM_HEIGHT:uint = TILESIZE * 26;
		private static const TM_OFFSET:uint = (TM_WIDTH - WIDTH) / 2;
		
		private var borderCamera:FlxCamera;
		private var gameCamera:FlxCamera;
		private var border:FlxSprite;
		private var level:FlxTilemap;
		private var player:Player;
		
		private var camera:Camera;
		
		private var bottomText:FlxText;
		
		override public function create():void
		{	
			FlxG.worldBounds = new FlxRect(-10, -10, TM_WIDTH + 20, TM_HEIGHT + 20);
			
			gameCamera = new FlxCamera(30 - TM_OFFSET, 30, TM_WIDTH, HEIGHT);
			borderCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			
			FlxG.resetCameras(gameCamera);
			FlxG.addCamera(borderCamera);
			FlxG.bgColor = 0xffaaaaaa;
			borderCamera.bgColor = 0x00000000;
			
			
			level = new FlxTilemap();
			var data:Array = new Array(
				1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1,
				0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0,
				0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0,
				0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1,
				1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1 );
			level.loadMap(FlxTilemap.arrayToCSV(data,13), ImgTiles, 35, 35, FlxTilemap.AUTO);
			level.cameras = new Array(gameCamera);
			add(level);
			
			player = new Player(TM_WIDTH/2, TM_HEIGHT*3/4);
			gameCamera.scroll.y = HEIGHT;
			player.x -= player.width/2;
			player.cameras = new Array(gameCamera);
			add(player);
			
			border = new FlxSprite(0, 0, ImgBorder);
			border.cameras = new Array(borderCamera);
			add(border);
			
			bottomText = new FlxText(50, 500, 500, "leap of faith");
            bottomText.setFormat("aaaiight", 65, 0x00000000, "left");
			bottomText.cameras = new Array(borderCamera);
			add(bottomText);
			
			gameCamera.setBounds(0, 0, TM_WIDTH, TM_HEIGHT);
			//gameCamera.follow(player);		
			//gameCamera.deadzone = new FlxRect(0, 100, WIDTH, HEIGHT);
			
			camera = new Camera(gameCamera, player);
			add(camera);
		}
		
		override public function update():void
		{	
			super.update();
			
			var playerScreenY:int = player.y - gameCamera.scroll.y;
			
			// IF FALLING DOWN, OUTSIDE THE SCREEN
			if (playerScreenY > HEIGHT) {
				player.y -= playerScreenY + player.height;
			} else {
				if (playerScreenY + player.height < HEIGHT && 
					playerScreenY + player.height > TILESIZE * 2) {
						FlxG.collide(level,player);
					}
			}
			
			// COLLISION
			if (player.x < TM_OFFSET) {
				player.x = TM_OFFSET;
				player.velocity.x = -player.velocity.x;
			}
			if (player.x + player.width > TM_WIDTH - TM_OFFSET) {
				player.x = TM_WIDTH - TM_OFFSET - player.width;
				player.velocity.x = -player.velocity.x;
			}
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}
