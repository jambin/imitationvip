# ImitationVIP
使用Flutter，模仿VIP商城

测试发现，如果图片信息比较多，当快速移动的时候，导致Image报错，如品牌墙里面的ListView.
暂时通过字母导航事件控制了listview刷新的时机。但会导致图片暂时不能显示bug.release版本更流畅，
debug确实有卡顿情况。
