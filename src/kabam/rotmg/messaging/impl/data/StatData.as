package kabam.rotmg.messaging.impl.data {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

import kabam.rotmg.text.model.TextKey;

public class StatData {
    public static const MAX_HP_STAT:int = 0;
    public static const HP_STAT:int = 1;
    public static const SIZE_STAT:int = 2;
    public static const MAX_MP_STAT:int = 3;
    public static const MP_STAT:int = 4;
    public static const NEXT_LEVEL_EXP_STAT:int = 5;
    public static const EXP_STAT:int = 6;
    public static const LEVEL_STAT:int = 7;
    public static const ATTACK_STAT:int = 20;
    public static const DEFENSE_STAT:int = 21;
    public static const SPEED_STAT:int = 22;
    public static const INVENTORY_0_STAT:int = 8;
    public static const INVENTORY_1_STAT:int = 9;
    public static const INVENTORY_2_STAT:int = 10;
    public static const INVENTORY_3_STAT:int = 11;
    public static const INVENTORY_4_STAT:int = 12;
    public static const INVENTORY_5_STAT:int = 13;
    public static const INVENTORY_6_STAT:int = 14;
    public static const INVENTORY_7_STAT:int = 15;
    public static const INVENTORY_8_STAT:int = 16;
    public static const INVENTORY_9_STAT:int = 17;
    public static const INVENTORY_10_STAT:int = 18;
    public static const INVENTORY_11_STAT:int = 19;
    public static const VITALITY_STAT:int = 26;
    public static const WISDOM_STAT:int = 27;
    public static const DEXTERITY_STAT:int = 28;
    public static const CONDITION_STAT:int = 29;
    public static const NUM_STARS_STAT:int = 30;
    public static const NAME_STAT:int = 31;
    public static const TEX1_STAT:int = 32;
    public static const TEX2_STAT:int = 33;
    public static const MERCHANDISE_TYPE_STAT:int = 34;
    public static const CREDITS_STAT:int = 35;
    public static const MERCHANDISE_PRICE_STAT:int = 36;
    public static const ACTIVE_STAT:int = 37;
    public static const ACCOUNT_ID_STAT:int = 38;
    public static const FAME_STAT:int = 39;
    public static const MERCHANDISE_CURRENCY_STAT:int = 40;
    public static const CONNECT_STAT:int = 41;
    public static const MERCHANDISE_COUNT_STAT:int = 42;
    public static const MERCHANDISE_MINS_LEFT_STAT:int = 43;
    public static const MERCHANDISE_DISCOUNT_STAT:int = 44;
    public static const MERCHANDISE_RANK_REQ_STAT:int = 45;
    public static const MAX_HP_BOOST_STAT:int = 46;
    public static const MAX_MP_BOOST_STAT:int = 47;
    public static const ATTACK_BOOST_STAT:int = 48;
    public static const DEFENSE_BOOST_STAT:int = 49;
    public static const SPEED_BOOST_STAT:int = 50;
    public static const VITALITY_BOOST_STAT:int = 51;
    public static const WISDOM_BOOST_STAT:int = 52;
    public static const DEXTERITY_BOOST_STAT:int = 53;
    public static const OWNER_ACCOUNT_ID_STAT:int = 54;
    public static const RANK_REQUIRED_STAT:int = 55;
    public static const NAME_CHOSEN_STAT:int = 56;
    public static const CURR_FAME_STAT:int = 57;
    public static const NEXT_CLASS_QUEST_FAME_STAT:int = 58;
    public static const LEGENDARY_RANK_STAT:int = 59;
    public static const SINK_LEVEL_STAT:int = 60;
    public static const ALT_TEXTURE_STAT:int = 61;
    public static const GUILD_NAME_STAT:int = 62;
    public static const GUILD_RANK_STAT:int = 63;
    public static const BREATH_STAT:int = 64;
    public static const XP_BOOSTED_STAT:int = 65;
    public static const XP_TIMER_STAT:int = 66;
    public static const LD_TIMER_STAT:int = 67;
    public static const LT_TIMER_STAT:int = 68;
    public static const BACKPACK_0_STAT:int = 71;
    public static const BACKPACK_1_STAT:int = 72;
    public static const BACKPACK_2_STAT:int = 73;
    public static const BACKPACK_3_STAT:int = 74;
    public static const BACKPACK_4_STAT:int = 75;
    public static const BACKPACK_5_STAT:int = 76;
    public static const BACKPACK_6_STAT:int = 77;
    public static const BACKPACK_7_STAT:int = 78;
    public static const HASBACKPACK_STAT:int = 79;
    public static const TEXTURE_STAT:int = 80;
    public static const PET_INSTANCEID_STAT:int = 81;
    public static const PET_NAME_STAT:int = 82;
    public static const PET_TYPE_STAT:int = 83;
    public static const PET_RARITY_STAT:int = 84;
    public static const PET_MAXABILITYPOWER_STAT:int = 85;
    public static const PET_FAMILY_STAT:int = 86;
    public static const PET_FIRSTABILITY_POINT_STAT:int = 87;
    public static const PET_SECONDABILITY_POINT_STAT:int = 88;
    public static const PET_THIRDABILITY_POINT_STAT:int = 89;
    public static const PET_FIRSTABILITY_POWER_STAT:int = 90;
    public static const PET_SECONDABILITY_POWER_STAT:int = 91;
    public static const PET_THIRDABILITY_POWER_STAT:int = 92;
    public static const PET_FIRSTABILITY_TYPE_STAT:int = 93;
    public static const PET_SECONDABILITY_TYPE_STAT:int = 94;
    public static const PET_THIRDABILITY_TYPE_STAT:int = 95;
    public static const NEW_CON_STAT:int = 96;
    public static const FORTUNE_TOKEN_STAT:int = 97;
    public static const SUPPORTER_POINTS_STAT:int = 98;
    public static const SUPPORTER_STAT:int = 99;
    public static const CHALLENGER_STARBG_STAT:int = 100;
    public static const PLAYER_ID:int = 101;
    public static const PROJECTILE_SPEED_MULT:int = 102;
    public static const PROJECTILE_LIFE_MULT:int = 103;
    public static const OPENED_AT_TIMESTAMP:int = 104;
    public static const EXALTED_ATTACK:int = 105;
    public static const EXALTED_DEFENSE:int = 106;
    public static const EXALTED_SPEED:int = 107;
    public static const EXALTED_VITALITY:int = 108;
    public static const EXALTED_WISDOM:int = 109;
    public static const EXALTED_DEXTERITY:int = 110;
    public static const EXALTED_HEALTH:int = 111;
    public static const EXALTED_MANA:int = 112;
    public static const EXALTATION_BONUS_DAMAGE:int = 113;
    public static const PROJECTILE_OWNER_ID:int = 114;
    public static const GRAVE_ACCOUNT_ID:int = 115;
    public static const QUICKSLOT_ITEM_1:int = 116;
    public static const QUICKSLOT_ITEM_2:int = 117;
    public static const QUICKSLOT_ITEM_3:int = 118;
    public static const QUICKSLOT_UPGRADE:int = 119;
    public static const FORGEFIRE_STAT:int = 120;

    public static function statToName(statId:int):String {
        switch (statId) {
            case StatData.MAX_HP_STAT:
                return TextKey.STAT_DATA_MAXHP;
            case StatData.HP_STAT:
                return TextKey.STATUS_BAR_HEALTH_POINTS;
            case StatData.SIZE_STAT:
                return TextKey.STAT_DATA_SIZE;
            case StatData.MAX_MP_STAT:
                return TextKey.STAT_DATA_MAXMP;
            case StatData.MP_STAT:
                return TextKey.STATUS_BAR_MANA_POINTS;
            case StatData.EXP_STAT:
                return TextKey.STAT_DATA_XP;
            case StatData.LEVEL_STAT:
                return TextKey.STAT_DATA_LEVEL;
            case StatData.ATTACK_STAT:
                return TextKey.STAT_MODEL_ATTACK_LONG;
            case StatData.DEFENSE_STAT:
                return TextKey.STAT_MODEL_DEFENSE_LONG;
            case StatData.SPEED_STAT:
                return TextKey.STAT_MODEL_SPEED_LONG;
            case StatData.VITALITY_STAT:
                return TextKey.STAT_MODEL_VITALITY_LONG;
            case StatData.WISDOM_STAT:
                return TextKey.STAT_MODEL_WISDOM_LONG;
            case StatData.DEXTERITY_STAT:
                return TextKey.STAT_MODEL_DEXTERITY_LONG;
            default:
                return TextKey.STAT_DATA_UNKNOWN_STAT;
        }
    }

    public function StatData() {
        super();
    }

    public var statType_:uint = 0;
    public var statValue_:int;
    public var strStatValue_:String;
    public var secondaryValue:int;

    public function isStringStat():Boolean {
        switch (this.statType_) {
            case NAME_STAT:
            case GUILD_NAME_STAT:
            case PET_NAME_STAT:
            case ACCOUNT_ID_STAT:
            case OWNER_ACCOUNT_ID_STAT:
            case GRAVE_ACCOUNT_ID:
                return true;
            default:
                return false;
        }
    }

    public function parseFromInput(data:IDataInput):void {
        this.statType_ = data.readUnsignedByte();
        if (!this.isStringStat())
            this.statValue_ = CompressedInt.read(data);
        else
            this.strStatValue_ = data.readUTF();

        this.secondaryValue = CompressedInt.read(data);
    }

    public function writeToOutput(data:IDataOutput):void {
        data.writeByte(this.statType_);
        if (!this.isStringStat())
            data.writeInt(this.statValue_);
        else
            data.writeUTF(this.strStatValue_);
    }

    public function toString():String {
        if (!this.isStringStat())
            return "[" + this.statType_ + ": " + this.statValue_ + "]";
        return "[" + this.statType_ + ": \"" + this.strStatValue_ + "\"]";
    }
}
}