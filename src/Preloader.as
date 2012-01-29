package
{
	import mochi.as3.*;
    import org.flixel.system.FlxPreloader;
    public class Preloader extends FlxPreloader
    {
        public function Preloader():void
        {
			MochiServices.connect("4e6057591114dac9", root);
            className = "main";
            super();
        }

        /* to make custom preloader, uncomment the following
        and look at FlxPreloader.as code for guidance */
        /*
        public override function create():void
        {
            _buffer = new Sprite();
            addChild(_buffer);
            // Add stuff to the buffer...
        }

        public override function update(PERCENT:Number):void
        {
            // Update the graphics...
        }
        */
    }
}
