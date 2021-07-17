package kabam.rotmg.arena.component
{
import com.company.assembleegameclient.ui.GuildText;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import flash.display.Bitmap;
import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class AbridgedPlayerTooltip extends ToolTip
{


    public function AbridgedPlayerTooltip(param1:ArenaLeaderboardEntry)
    {
        var _loc5_:* = null;
        var _loc3_:Bitmap = new Bitmap();
        _loc3_.bitmapData = param1.playerBitmap;
        _loc3_.scaleX = 0.75;
        _loc3_.scaleY = 0.75;
        _loc3_.y = 5;
        addChild(_loc3_);
        var _loc2_:StaticTextDisplay = new StaticTextDisplay();
        _loc2_.setSize(14).setBold(true).setColor(16777215);
        _loc2_.setStringBuilder(new StaticStringBuilder(param1.name));
        _loc2_.x = 40;
        _loc2_.y = 5;
        addChild(_loc2_);
        if(param1.guildName)
        {
            _loc5_ = new GuildText(param1.guildName,param1.guildRank,"");
            _loc5_.x = 40;
            _loc5_.y = 20;
            addChild(_loc5_);
        }
        super(3552822,0.5,16777215,1);
        var _loc4_:EquippedGrid = new EquippedGrid(null,param1.slotTypes,null);
        _loc4_.x = 5;
        _loc4_.y = !!_loc5_?_loc5_.y + _loc5_.height - 5:55;
        _loc4_.setItems(param1.equipment);
        addChild(_loc4_);
    }
}
}
