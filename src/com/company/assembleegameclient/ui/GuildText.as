package com.company.assembleegameclient.ui
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.GuildUtil;
import com.company.util.SpriteUtil;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class GuildText extends Sprite
{


    private const DEFAULT_FILTER:DropShadowFilter = new DropShadowFilter(0,0,0);

    private var name_:String;

    private var rank_:int;

    private var icon_:Bitmap;

    private var sameGuild:Boolean;

    private var guildName_:TextFieldDisplayConcrete;

    public function GuildText(param1:String, param2:int, param3:String, param4:int = 0)
    {
        super();
        this.icon_ = new Bitmap(null);
        this.icon_.y = -8;
        this.icon_.x = -8;
        var _loc5_:int = param4 == 0?0:Number(param4 - (this.icon_.width - 16));
        this.guildName_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(_loc5_);
        this.guildName_.mouseChildren = false;
        this.guildName_.setAutoSize("left");
        this.guildName_.filters = [DEFAULT_FILTER];
        this.guildName_.x = 24;
        this.guildName_.y = 2;
        this.draw(param1,param2,param3);
    }

    public function draw(param1:String, param2:int, param3:String) : void
    {
        if(this.name_ == param1 && param2 == param2)
        {
            return;
        }
        this.name_ = param1;
        this.rank_ = param2;
        if(this.name_ == null || this.name_ == "")
        {
            SpriteUtil.safeRemoveChild(this,this.icon_);
            SpriteUtil.safeRemoveChild(this,this.guildName_);
        }
        else
        {
            this.icon_.bitmapData = GuildUtil.rankToIcon(Parameters.data.customGuildRank != -1 && param1 == param3?Parameters.data.customGuildRank:this.rank_,20);
            SpriteUtil.safeAddChild(this,this.icon_);
            this.guildName_.setStringBuilder(new StaticStringBuilder(Parameters.data.customGuildName != "" && param1 == param3?Parameters.data.customGuildName:this.name_));
            SpriteUtil.safeAddChild(this,this.guildName_);
        }
    }
}
}
