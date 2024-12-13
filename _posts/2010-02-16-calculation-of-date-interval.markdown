---
author: pandao
comments: false
date: 2010-02-16 11:07:55+00:00
layout: post
slug: calculation-of-date-interval
title: 日期间隔时间差计算-HTML实现和PHP实现
thread: 17
categories:
- Blog相关
- 杂七杂八
---

OMG…我辛辛苦苦写了那么多，居然被自己一个不小心关掉了…(当然没保存)。重来吧…

今天呢，哎呀不对，是昨天。昨天呢，我女朋友小猫问我：“今天是我们见面的第几天啊？”这么复杂的东西我怎么记得住！不过幸好，我记得是从2007年10月10日算起的~(谢谢小猫为了我好记选择了这个简单的日子~:-D),查了以下，2007年10月10日是周三，而明天，不对，是今天2010年2月17日也是周三，而上次(一周内)小猫曾经告诉过我是第855天了~一周7天，那么855+n=7*m(n<7),得出m=123,既是123*7=861天！那么昨天(2010/2/16)就是第860天！完美解决！啊哈哈哈哈，真相只有一个！本少爷真是太聪明了！
不过呢，这个倒是引起了我对日期差算法的，很明显，不能以后每次都这么算吧！

先说下HTML实现：
CODE：

    
    <SCRIPT LANGUAGE="JavaScript"> function isValidDate(dateStr) { var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{4})$/; var matchArray = dateStr.match(datePat);  if (matchArray == null) { alert(dateStr + " 日期格式不正确.") return false; } month = matchArray[1];  day = matchArray[3]; year = matchArray[4]; if (month < 1 || month > 12) {  alert("月必须在01和12之间."); return false; } if (day < 1 || day > 31) { alert("日必须在01到31之间."); return false; } if ((month==4 || month==6 || month==9 || month==11) && day==31) { alert("月份 "+month+" 没有31天!") return false; } if (month == 2) { // check for february 29th var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)); if (day>29 || (day==29 && !isleap)) { alert("二月 " + year + " 没有 " + day + " 天!"); return false;    } } return true; } function isValidTime(timeStr) { var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/; var matchArray = timeStr.match(timePat); if (matchArray == null) { alert("时间格式不正确."); return false; } hour = matchArray[1]; minute = matchArray[2]; second = matchArray[4]; ampm = matchArray[6]; if (second=="") { second = null; } if (ampm=="") { ampm = null } if (hour < 0  || hour > 23) { alert("小时必须在01到12之间. (或者00到23之间)"); return false; } if (hour <= 12 && ampm == null) { if (confirm("Please indicate which time format you are using.  OK = Standard Time, CANCEL = Military Time")) { alert("You must specify AM or PM."); return false;    } } if  (hour > 12 && ampm != null) { alert("You can't specify AM or PM for military time."); return false; } if (minute < 0 || minute > 59) { alert ("Minute must be between 0 and 59."); return false; } if (second != null && (second < 0 || second > 59)) { alert ("秒必须在00到59之间."); return false; } return true; } function dateDiff(dateform) { date1 = new Date(); date2 = new Date(); diff  = new Date(); if (isValidDate(dateform.firstdate.value) && isValidTime(dateform.firsttime.value)) { // Validates first date  date1temp = new Date(dateform.firstdate.value + " " + dateform.firsttime.value); date1.setTime(date1temp.getTime()); } else return false; // otherwise exits if (isValidDate(dateform.seconddate.value) && isValidTime(dateform.secondtime.value)) { // Validates second date  date2temp = new Date(dateform.seconddate.value + " " + dateform.secondtime.value); date2.setTime(date2temp.getTime()); } else return false; // otherwise exits // sets difference date to difference of first date and second date diff.setTime(Math.abs(date1.getTime() - date2.getTime())); timediff = diff.getTime(); weeks = Math.floor(timediff / (1000 * 60 * 60 * 24 * 7)); timediff -= weeks * (1000 * 60 * 60 * 24 * 7); days = Math.floor(timediff / (1000 * 60 * 60 * 24));  timediff -= days * (1000 * 60 * 60 * 24); hours = Math.floor(timediff / (1000 * 60 * 60));  timediff -= hours * (1000 * 60 * 60); mins = Math.floor(timediff / (1000 * 60));  timediff -= mins * (1000 * 60); secs = Math.floor(timediff / 1000);  timediff -= secs * 1000; dateform.difference.value = weeks + " 周, " + days + " 天, " + hours + " 时, " + mins + " 分, and " + secs + " 秒"; return false; // form should never submit, returns false } //  End --> </script> <center><form onSubmit="return dateDiff(this);"> <p>　</p> <table bgcolor="#F8F8F8"> <tr><td width="612"> <pre> 第一个日期: <input type=text name=firstdate value="" size=10 maxlength=10>(格式：08/09/1999 表示1999年8月9日)       时间: <input type=text name=firsttime value="08:09:10AM" size=10 maxlength=10>(格式：08:04:05Am 表示上午8点04分05秒,下午为pm.也可18:04:05) 第二个日期: <input type=text name=seconddate value="" size=10 maxlength=10>(格式：08/09/2005 表示1999年8月9日)<a href="http://www.zhongguosou.com"> </a>       时间: <input type=text name=secondtime value="08:09:10AM" size=10 maxlength=10>(格式：08:04:05Am 表示上午8点04分05秒,下午为pm.也可18:04:05) <center><input type=submit value="计算差别"> 计算日期时间的差别为:<br> <input type=text name=difference value="" size=60> </center> </pre> </td></tr> </table> </form> </center>     </TD>       </TBODY></TABLE>


然后是PHP实现，貌似没有输入输出框，完全基于源码：
CODE：

    
    <?PHP
    //今天与2007年10月10日相差多少天
    $Date_1=date("Y-m-d");
    $Date_2="2007-10-10";
    $d1=strtotime($Date_1);
    $d2=strtotime($Date_2);
    $Days=round(($d1-$d2)/3600/24);
    Echo   "今天与2007年10月10日相差".$Days."天";
    Echo "<br>";
    
    //今天到2012年12月21日还有多少天
    $Date_1=date("Y-m-d");
    $Date_2="2012-12-21";
    $d1=strtotime($Date_1);
    $d2=strtotime($Date_2);
    $Days=round(($d2-$d1)/3600/24);
    Echo   "今天到2012年12月21日(世界末日！好可怕！)还有".$Days."天";
    
    ?>


它看起来就像是[这样](http://zyzl.110mb.com/fp-content/attachs/riqi.php)。
别笑，没准你会用到。
