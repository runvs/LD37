package;

import flash.net.FileFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Guest extends FlxSprite
{
	private var _actions : Array<GuestAction>;
	
	public var _state :PlayState;
	public var Level : Int = 0;
	
	public var CanLeave : Bool = false;
	
	public var _roomName : String = "";
	
	public var _satisfactionFactor : Float = 1.0;
	public var movefactor : Float = 1.0;
	private var _infoBG : FlxSprite;
	private var _infoText : FlxText;
	
	public function new(state:PlayState) 
	{
		super( -10, GP.GroundLevel);
		_state = state;
		this.offset.set(0, GP.GuestSizeInPixel);
		this.makeGraphic(GP.GuestSizeInPixel, GP.GuestSizeInPixel, FlxColor.BLUE);
		//this.velocity.set(32);
		_actions = new Array<GuestAction>();
		
		var w1 : GuestActionWalk = new GuestActionWalk(this);
		w1.targetRoom = "reception";
		_actions.push(w1);
		
		var a1 : GuestActionAssignRoom = new GuestActionAssignRoom(this);
		_actions.push(a1);
		
		_infoText = new FlxText(0, 0, 100, "");
		_infoBG = new FlxSprite(0, 0);
		_infoBG.makeGraphic(100, 32, FlxColor.GRAY);
		movefactor = FlxG.random.floatNormal(1, 0.5);
	}
	
	public override function update(elapsed:Float) : Void 
	{
		super.update(elapsed);
		Level = Std.int((this.y-GP.GuestSizeInPixel) / GP.RoomSizeInPixel) ;
		//trace(_actions.length);
		if (_actions.length > 0)
		{
			_actions[0].update(elapsed);
			if (_actions[0].IsFinished())
			{
				NextAction();
			}
		}
		_infoBG.setPosition(this.x + GP.GuestSizeInPixel, this.y - GP.GuestSizeInPixel);
		_infoText.setPosition(this.x + GP.GuestSizeInPixel, this.y - GP.GuestSizeInPixel);
		_infoText.text = "Level: " + Std.string(Level) + "\nActions[" + _actions.length + "] = " + ((_actions.length != 0)?  _actions[0].name : "--" );
	}
	
	function NextAction():Void 
	{
		var a : GuestAction = _actions[0];
		_actions.remove(a);
		a.DoFinish();
		if (_actions.length > 0)
			_actions[0].Activate();
	}

	public function AddActionToBegin(a:GuestAction) 
	{
		//trace("AddBegin " + _actions.length );
		if (a == null) return;
		
		if (_actions.length > 0)
		{
			_actions[0].activated = false;
		}
		
		//a.Activate();
		var _newActions : Array<GuestAction> = new Array<GuestAction>();
		_newActions.push(a);
		//trace("AddBegin newactions " + _newActions.length );
		_actions = _newActions.concat(_actions);
		//_actions = _newActions;
		//trace("AddBegin End " + _actions.length );
	}
	
	public function AddAction(a:GuestAction) : Void
	{
		_actions.push(a);
	}
	
	public override function draw()
	{
		super.draw();
		_infoBG.draw();
		
		_infoText.draw();
	}
	
}