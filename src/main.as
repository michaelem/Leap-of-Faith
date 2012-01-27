package
{
    import org.flixel.*;

    [SWF(width="500", height="600", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class main extends FlxGame
    {
        public function main():void
        {
            super(500,600,IngameState,1);
            forceDebugger = true;
        }
    }
}
