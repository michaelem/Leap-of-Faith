package
{
			
	import mochi.as3.*; 
	import flash.ui.Mouse;
	import flash.display.Sprite;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class IngameState extends FlxState
	{
		// file imports
		
		// graphics
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		[Embed(source="../assets/tiles_cardboard.png")] private static var ImgTiles:Class;
		// fonts
		[Embed(source="../assets/aaaiight.ttf", fontFamily="aaaiight", embedAsCFF="false")] private	var	aaaiightFont:String;
		[Embed(source="../assets/MostlyMono.ttf", fontFamily="MostlyMono", embedAsCFF="false")] private	var	MostlyMonoFont:String;
		// sound effects
		[Embed(source="../assets/Explosion34.mp3")] private var SndExplosion:Class;
		[Embed(source="../assets/woosh.mp3")] private var SndWoosh:Class;
		[Embed(source="../assets/ratsch.mp3")] private var SndRatsch:Class;
		// music
		[Embed(source="../assets/theme.mp3")] private var SndTheme:Class;
		
		
		// static vars
		
		private static const WIDTH:uint = 440;
		private static const HEIGHT:uint = 450;
		
		private static const TILESIZE:uint = 35;
		private static const TM_WIDTH:uint = TILESIZE * 13;
		private static const TM_HEIGHT:uint = TILESIZE * 26;
		private static const TM_OFFSET:uint = (TM_WIDTH - WIDTH) / 2;
		private static const START_SCREEN:uint = 0;

		private static const WORKING_ARRAY_SIZE:int = 338;
		private static const WORKING_ARRAY_SIZE_HALF:int = 169;
		
		// cameras
		private var camera:Camera;
		private var borderCamera:FlxCamera;
		private var gameCamera:FlxCamera;
		
		// playground
		private var background:Background;
		private var border:FlxSprite;
		private var clouds:Clouds;
		
		// tilemap
		private var level:FlxTilemap;
		private var levelData:Array;
		private var levelCounter:int;
		
		// sprites and sprite groups
		private var player:Player;		
		private var spritesFromTiles:FlxGroup;		
		private var stones:FlxGroup;		
		private var credits:FlxGroup;
		
		// score text
		private var bottomText:FlxText;
		private var bottomText2:FlxText;
		
		private var progress:Number = 0;
		
		private var timeCounter:Number = 0;
		
		private var endTimer:FlxTimer;
		private var end:Boolean;
		
		override public function create():void
		{	
			// init playground
			FlxG.worldBounds = new FlxRect(-10, -10, TM_WIDTH + 20, TM_HEIGHT + 20);
			FlxG.play(SndTheme, 1.0, true);
			FlxG.bgColor = 0xffaaaaaa;
			
			gameCamera = new FlxCamera(30 - TM_OFFSET, 30, TM_WIDTH, HEIGHT);
			gameCamera.setBounds(0, 0, TM_WIDTH, TM_HEIGHT);		
			//gameCamera.deadzone = new FlxRect(0, 100, WIDTH, HEIGHT);
			gameCamera.scroll.y = HEIGHT;
			
			borderCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			borderCamera.bgColor = 0x00000000;

			border = new FlxSprite(0, 0, ImgBorder);
			border.cameras = [borderCamera];
			add(border);

			background = new Background([gameCamera]);
			add(background);
			
			FlxG.resetCameras(gameCamera);
			FlxG.addCamera(borderCamera);
			
			// init level
			level = new FlxTilemap();
			levelCounter = 0;
			
			levelData = new Array();
			initMap();
			level.loadMap(FlxTilemap.arrayToCSV(levelData,13), ImgTiles, 35, 35, FlxTilemap.OFF);
			level.cameras = [gameCamera];
			add(level);
			
			
			clouds = new Clouds();
			clouds.setCameras([gameCamera]);
			add(clouds);
			
			// sprites and sprite groups
			player = new Player(70, TM_HEIGHT-120);
			player.x -= player.width/2;
			player.cameras = [gameCamera];
			add(player);
			
			//gameCamera.follow(player);
			camera = new Camera(gameCamera, player);
			add(camera);
			
			spritesFromTiles = new FlxGroup();
			spritesFromTiles.cameras = [gameCamera];
			add(spritesFromTiles);

			stones = new FlxGroup();
			add(stones);
			
			credits = new FlxGroup();
			add(credits);
			//insertCredits();
			
			// texts
			// "leap of faith" - bottomText
			//bottomText = new FlxText(50, 500, 500, "leap of faith");
            //bottomText.setFormat("aaaiight", 65, 0x00000000, "left");
			//bottomText.cameras = [borderCamera];
			//add(bottomText);
			
			// "floor xy" - bottomtext aaaiight
			bottomText = new FlxText(35, 500, 500, "Floor 1");
			bottomText.setFormat("aaaiight",25, 0x00000000, "left");
			bottomText.cameras = [borderCamera];
			add(bottomText);
			
			endTimer = new FlxTimer();

			end = false;
		}
		
		override public function update():void
		{				
			background.scroll = progress * 0.6;
			
			var playerScreenY:int = player.y - gameCamera.scroll.y;
			
			// IF FALLING DOWN, OUTSIDE THE SCREEN
			if (playerScreenY > HEIGHT) {
				FlxG.play(SndWoosh);
				player.y -= playerScreenY + player.height;
				player.last.y = player.y;
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
			
			for each (var w:FlxSprite in stones.members) {
				if (w != null) {
					var wScreenY:int = w.y - gameCamera.scroll.y;
					//FlxG.log(w.getScreenXY().y);
						if (wScreenY > HEIGHT) {
							w.y -= wScreenY + w.height;
							w.last.y = w.y;
						}
						if (wScreenY > TILESIZE && wScreenY + w.height < HEIGHT) {
							w.solid = true;
						}
				}
			}
			
			FlxG.collide(stones, player, stonePlayerCollision);
			FlxG.collide(stones, level, stoneLevelCollision);
			//FlxG.overlap(credits, player, creditPlayerCollision);
			
			
			// LOAD MAP
			if (gameCamera.scroll.y == 0) {
				levelData = swapMap(levelData);
				level.loadMap(FlxTilemap.arrayToCSV(levelData,13), ImgTiles, 35, 35, FlxTilemap.OFF);
				// update object positions
				// player
				player.y += TM_HEIGHT/2;
				player.last.y += TM_HEIGHT/2;
				// camera
				gameCamera.scroll.y += TM_HEIGHT/2;
				
				var s:FlxSprite;
				for each (s in spritesFromTiles.members) {
					if (s != null) {
						s.y += TM_HEIGHT/2;
						if (s.y - gameCamera.scroll.y > HEIGHT) {
							spritesFromTiles.remove(s);
							remove(s);
						}
					}
				}	// remove old sprites		
				for each (s in stones.members) {
					if (s != null) {
						s.y += TM_HEIGHT/2;
						if (s.y - gameCamera.scroll.y > HEIGHT) {
							spritesFromTiles.remove(s);
							remove(s);
						}
					}
				}	// remove old sprites	
				//insertCredits();		
			}
			
			if (player.pain && player.isDead()) {
				 
				 FlxG.shake(0.10, 0.5, function():void{
					    var respawnPoints:Array = level.getTileCoords(5,false);
						bottomText.text="killed at floor " + respawnPoints[0].x + "/" +  respawnPoints[0].y + respawnPoints[1].x + "/" +  respawnPoints[1].y;
                        if (respawnPoints[0].y > respawnPoints[1].y)
                        {
                            gameCamera.scroll.y = respawnPoints[0].y - 150;
                            player.x = respawnPoints[0].x + player.width/2;
                            player.y = respawnPoints[0].y - player.height;
                        } 
                        else 
                        {
                            gameCamera.scroll.y = respawnPoints[1].y - 150;
                            player.x = respawnPoints[1].x + player.width/2;
                            player.y = respawnPoints[1].y - player.height;
                        }
                        player.resetPain();
                }, false, 0);
			}
			
			timer();
			
			var oldScrollPos:Number = gameCamera.scroll.y;
			super.update();
			progress += oldScrollPos - gameCamera.scroll.y;
		}
		
		private function stonePlayerCollision(stone:Stone, player:Player):void	//function called when player touches a bouncy block
		{
			if (stone.isHit) return;
			player.pain = true;
			stone.hit();
			FlxG.play(SndRatsch);
		}
		
		private function stoneLevelCollision(stone:Stone, level:FlxTilemap):void	//function called when player touches a bouncy block
		{
			var stoneScreenY:int = stone.y - gameCamera.scroll.y;
			if (stoneScreenY + stone.height > HEIGHT ||
				stoneScreenY + stone.height < TILESIZE) {
				stone.solid = false; 
				return;
			}
			if (stone.isHit) return;
			stone.hit();
			FlxG.play(SndRatsch);
		}
		
		private function creditPlayerCollision(credit:Credit, player:Player):void	//function called when player touches a bouncy block
		{
			var tIndex:int = getIndexByWorldCoords(credit.x,credit.y);
			level.setTileByIndex(tIndex ,0,true);
			levelData[tIndex] = 0;
			credit.kill();
			// DO HIGHSCORE
		}
		
		private function onEndTimer(t:FlxTimer):void
		{
			Mouse.show();
			var o:Object = { n: [1, 3, 9, 9, 7, 12, 8, 13, 14, 4, 5, 10, 15, 2, 14, 6], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
			var tMillisec:int = timeCounter*1000;
			MochiScores.showLeaderboard({boardID: boardID, score: tMillisec, onClose: function():void { Mouse.hide(); FlxG.switchState(new MenuState()); }});
		}
		
		private function timer():void {
			if (levelCounter < 13 || player.y + player.height > 420) {
				timeCounter += FlxG.elapsed;
			} else {
				if (!end) {
					end = true;
					endTimer.start(5, 1, onEndTimer);
				}
			}
			var tSeconds:int = FlxU.floor(timeCounter)%60;
			var tMinutes:int = FlxU.floor(FlxU.floor(timeCounter)/60);
			var tMillisec:int = (timeCounter%1)*100;
			var tTime:String = "time: ";

			if (tMinutes < 10) {
				tTime += "00"+tMinutes;
			} else if (tSeconds < 100) {
				tTime += "0"+tMinutes;
			} else {
				tTime += tMinutes;
			}
			tTime += " : ";
			if (tSeconds < 10) {
				tTime += "0"+tSeconds;
			} else {
				tTime += tSeconds;
			}
			tTime += " : ";
			if (tMillisec < 10) {
				tTime += "0"+tMillisec;
			} else {
				tTime += tMillisec;
			}
		
			bottomText.text = tTime;
		}
		
		private function levelCollision(tile:FlxTile, object:FlxObject):void	//function called when player touches a bouncy block
		{
			if (tile.index == 4 && object is Player && !((object as Player).pain)) {
				var r1:FlxRect = new FlxRect(object.x, object.y, object.width, object.height);
				var r2:FlxRect = new FlxRect(tile.x + 10, tile.y + 5, tile.width - 20, tile.height - 5);
				if ( object.y - object.last.y > 0.1 && object.y + object.height < tile.y + tile.height - 2 && r1.overlaps(r2) ) 	//The player will bounce if he collides with a bouncy block.
				{
					var sprite:FlxSprite  = new FlxSprite(tile.getMidpoint().x, tile.getMidpoint().y);
					sprite.cameras=[gameCamera];
					//spritesFromTiles.add(sprite)
					FlxG.play(SndExplosion);
					(object as Player).pain = true;
					(object as Player).y += 10;
	                //object.kill();
				}
			} else if (tile.index == 7) {
				FlxG.log("x "+tile.x+" y "+ tile.y);
				FlxG.log("index"+getIndexByWorldCoords(tile.x,tile.y+35));
				if (level.getTileByIndex(getIndexByWorldCoords(tile.x,tile.y+35)) == 6) {
					createStone(tile.x, tile.y+35);
					//FlxG.log("index"+getIndexByWorldCoords(tile.x,tile.y+35));
					//FlxG.log("num"+level.getTileByIndex(getIndexByWorldCoords(tile.x,tile.y+35)));
					level.setTileByIndex(getIndexByWorldCoords(tile.x,tile.y+35),0,true);
				}
				FlxG.collide(tile, object);
			} else if (tile.index == 6) {
							//FlxG.log("x "+tile.x+" y "+ tile.y);
							//FlxG.log("index"+getIndexByWorldCoords(tile.x,tile.y+35));
				createStone(tile.x, tile.y);
								//FlxG.log("index"+getIndexByWorldCoords(tile.x,tile.y+35));
								//FlxG.log("num"+level.getTileByIndex(getIndexByWorldCoords(tile.x,tile.y+35)));
				level.setTileByIndex(getIndexByWorldCoords(tile.x,tile.y),0,true);
				
				FlxG.collide(tile, object);
							
			} else {
				if (tile.index != 5 && tile.index != 8) FlxG.collide(tile, object);
			}
			
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
			stone.cameras = [gameCamera];
			stones.add(stone);
		}
		
		public function createCredit(X:uint,Y:uint):void
		{
			var credit:Credit = new Credit(X,Y);
			credit.cameras = [gameCamera];
			credits.add(credit);
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
			        levelDataTmp[WORKING_ARRAY_SIZE_HALF+i] = level.getTileByIndex(i);
			}
			
			levelCounter++;
			return levelDataTmp;
		}
		
		public function insertCredits():void
		{
		    // insert credits
			if (credits != null) {
				credits.clear();
				var creditPoints:Array = level.getTileCoords(8,false);
				for (var j:int = 0; j<creditPoints.length; j++) {
					createCredit(creditPoints[j].x+2, creditPoints[j].y+2)				
				}
			}	
		}
		
		public function getIndexByWorldCoords(x:int,y:int):int
		{
			var tX:int = FlxU.floor(x/TILESIZE)
			var tY:int = FlxU.floor(y/TILESIZE) 
			return tY * 13 + tX;
		}
	}
}
