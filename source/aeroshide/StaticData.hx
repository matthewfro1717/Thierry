package aeroshide;


/**
 * Datas that are static and will be forgotten when engine restarts.
 *
 * 
 */

class StaticData extends MusicBeatState
{
    public static var isAllowedToBop:Bool = false;
    public static var goingBadEndingRoute:Bool = false;
    public static var gotBadEnding:Bool = false;
    public static var using3DEngine:Bool = false;
    public static var isAllowedToDie:Bool = true;
    public static  var tunnelOpen:Bool = false;
    public static var badaiComesin:Bool = false;
    public static var tunnelHasOpened:Bool = false;
    public static var expungedSinging:Bool = false;
    public static var animaticaEngine:Bool = false;
    public static var debugMenu:Bool = false;
    public static var sartFade:Bool = false;
    public static var didPreload:Bool = false;
    public static var theresSecondDad:Bool = false;
    public static var secondDadAnim:Bool = false;
    public static var whoIsSinging:Int = 0;
    public static var fromCredits:Bool = false;
    
    public static var Optimize:Bool;

    public static function resetStaticData() 
    {
        isAllowedToBop = false;
        goingBadEndingRoute = false;
        using3DEngine = false;
        isAllowedToDie = true;
        tunnelOpen = false;
        badaiComesin = false;
        tunnelHasOpened = false;
        expungedSinging = false;
        animaticaEngine = false;
        debugMenu = false;
        sartFade = false;
        didPreload = false;
        theresSecondDad = false;
        whoIsSinging = 0;
        secondDadAnim = false;
        fromCredits = false;
    }
}
