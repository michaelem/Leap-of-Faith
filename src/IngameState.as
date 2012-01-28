package
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class IngameState extends FlxState
	{
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		[Embed(source="../assets/tiles_cardboard.png")] private static var ImgTiles:Class;
		[Embed(source="../assets/aaaiight.ttf", fontFamily="aaaiight", embedAsCFF="false")] private	var	aaaiightFont:String;
		
		private static const WIDTH:uint = 440;
		private static const HEIGHT:uint = 450;
		
		private static const TILESIZE:uint = 35;
		private static const TM_WIDTH:uint = TILESIZE * 13;
		private static const TM_HEIGHT:uint = TILESIZE * 26;
		private static const TM_OFFSET:uint = (TM_WIDTH - WIDTH) / 2;
		private static const START_SCREEN:uint = 0;

		private static const WORKING_ARRAY_SIZE:int = 338;
		private static const WORKING_ARRAY_SIZE_HALF:int = 169;
		
		private var borderCamera:FlxCamera;
		private var gameCamera:FlxCamera;
		private var border:FlxSprite;
		private var clouds:Clouds;
		private var level:FlxTilemap;
		private var levelData:Array;
		private var levelCounter:int;
		private var player:Player;
		private var background:Background;
		
		private var spritesFromTiles:FlxGroup;
		
		private var stones:FlxGroup;
		
		private var progress:Number = 0;
		
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
			
			background = new Background([gameCamera]);
			add(background);

			level = new FlxTilemap();
			levelCounter = 0;
			
			levelData = new Array();
			initMap();
			level.loadMap(FlxTilemap.arrayToCSV(levelData,13), ImgTiles, 35, 35, FlxTilemap.OFF);
			level.cameras = [gameCamera];

			add(level);
			player = new Player(TM_WIDTH/2, TM_HEIGHT*3/4);
			gameCamera.scroll.y = HEIGHT;

			clouds = new Clouds();
			clouds.setCameras([gameCamera]);
			add(clouds);

			player.x -= player.width/2;
			player.cameras = [gameCamera];
			add(player);
			
			border = new FlxSprite(0, 0, ImgBorder);
			border.cameras = [borderCamera];
			add(border);
			
			// "leap of faith" - bottomText
			//bottomText = new FlxText(50, 500, 500, "leap of faith");
            //bottomText.setFormat("aaaiight", 65, 0x00000000, "left");
			//bottomText.cameras = [borderCamera];
			//add(bottomText);
			
			// "floor xy" - bottomtext
			bottomText = new FlxText(35, 500, 500, "Floor 1");
			bottomText.setFormat("aaaiight", 25, 0x00000000, "left");
			bottomText.cameras = [borderCamera];
			add(bottomText);
			
			gameCamera.setBounds(0, 0, TM_WIDTH, TM_HEIGHT);
			//gameCamera.follow(player);		
			//gameCamera.deadzone = new FlxRect(0, 100, WIDTH, HEIGHT);
			
			camera = new Camera(gameCamera, player);
			add(camera);
			
			stones = new FlxGroup();
			stones.cameras = [gameCamera];
			add(stones);
			
			// check collision
			// spawn
			// fly
			// destroy
			//FlxG.collide(level, player, player.touched);
			//createStone(TM_WIDTH/2+100, TM_HEIGHT*3/4);
			
			spritesFromTiles = new FlxGroup();
			spritesFromTiles.cameras = [gameCamera];
			add(spritesFromTiles);
		}
		
		override public function update():void
		{				
			background.scroll = progress * 0.6;
			
			var playerScreenY:int = player.y - gameCamera.scroll.y;
			
			// IF FALLING DOWN, OUTSIDE THE SCREEN
			if (playerScreenY > HEIGHT) {
				player.y -= playerScreenY + player.height;
			} else {
				if (playerScreenY + player.height < HEIGHT && 
					playerScreenY + player.height > TILESIZE) {
						level.overlapsWithCallback(player, levelCollision);
					}
			}
			
			// COLLISION
			if (player.x < TM_OFFSET) {
				player.x = TM_OFFSET;
				player.velocity.x = -player.velocity.x;
				player.velocity.y = player.velocity.y-20;
			}
			if (player.x + player.width > TM_WIDTH - TM_OFFSET) {
				player.x = TM_WIDTH - TM_OFFSET - player.width;
				player.velocity.x = -player.velocity.x;
			}
			
			// LOAD MAP
			if (gameCamera.scroll.y == 0) {
				levelData = swapMap(levelData);
				level.loadMap(FlxTilemap.arrayToCSV(levelData,13), ImgTiles, 35, 35, FlxTilemap.OFF);
				player.y += TM_HEIGHT/2;
				player.last.y += TM_HEIGHT/2;
				gameCamera.scroll.y += TM_HEIGHT/2;
				
				// remove old sprites
				for each (var s:FlxSprite in spritesFromTiles.members) {
					if (s != null) {
						s.y += TM_HEIGHT/2;
						if (s.getScreenXY().y > HEIGHT) {
							spritesFromTiles.remove(s);
							remove(s);
						}
					}
				}
				
			}
			
			var oldScrollPos:Number = gameCamera.scroll.y;
			super.update();
			progress += oldScrollPos - gameCamera.scroll.y;
		}
		
		private function levelCollision(tile:FlxTile, object:FlxObject):void	//function called when player touches a bouncy block
		{
			if (tile.index == 4)	//The player will bounce if he collides with a bouncy block.
			{
                //bottomText.text="killed at floor " + (levelCounter+2);
                var respawnPoints:Array = level.getTileCoords(5,false);
                bottomText.text="killed at floor " + respawnPoints[0].x + "/" +  respawnPoints[0].y + respawnPoints[1].x + "/" +  respawnPoints[1].y;
                FlxG.shake(0.10, 0.5, function():void{
                        if (respawnPoints[0].y > respawnPoints[1].y)
                        {
                            gameCamera.scroll.y = respawnPoints[0].y - 150;
                            object.x = respawnPoints[0].x + object.width/2;
                            object.y = respawnPoints[0].y - object.height;
                        } 
                        else 
                        {
                            gameCamera.scroll.y = respawnPoints[1].y - 150;
                            object.x = respawnPoints[1].x + object.width/2;
                            object.y = respawnPoints[1].y - object.height;
                        }
                }, false, 0);
                //object.kill();
			}
				
            if (tile.index == 5)
                return;
			//if (tile.index == 3)
			//	createStone(TM_WIDTH/2+100, TM_HEIGHT*3/4);
			FlxG.collide(tile, object);
		}
		
		// goes to respawn point at screen 
		private function gotoScreen(screen:Number):void
		{
        
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		public function createStone(X:uint,Y:uint):void
		{
			var stone:Stone = new Stone(X,Y);
			stones.add(stone);
		}
		
		public function initMap():void
		{
			var levelDataTmp:Array = new Array(WORKING_ARRAY_SIZE);
			var i:int;
			// neue erste haelfte
			for(i=0; i<WORKING_ARRAY_SIZE_HALF; i++) {
			        levelData[i] = Screens.screens[START_SCREEN +1][i];
			}
			// neue zweite haelfte
			for(i=0; i<WORKING_ARRAY_SIZE_HALF; i++) {
			        levelData[WORKING_ARRAY_SIZE_HALF+i] = Screens.screens[START_SCREEN][i];
			}
		}
		
		public function swapMap(levelData:Array):Array
		{
		    bottomText.text = "floor " + (levelCounter+2);
			var levelDataTmp:Array = new Array(WORKING_ARRAY_SIZE);
			var i:int;
			// neue erste haelfte
			for(i=0; i<WORKING_ARRAY_SIZE_HALF; i++) {
			        levelDataTmp[i] = Screens.screens[START_SCREEN+2+levelCounter][i];
			}
			// neue zweite haelfte
			for(i=0; i<WORKING_ARRAY_SIZE_HALF; i++) {
			        levelDataTmp[WORKING_ARRAY_SIZE_HALF+i] = levelData[i];
			}
			levelCounter++;
			return levelDataTmp;
		}
		
	}
}
