extends Node2D

const FONT_REGULAR: Font = preload("res://assets/fonts/ArabicUI-Regular.ttf")
const FONT_BOLD: Font = preload("res://assets/fonts/ArabicUI-Bold.ttf")
const PROFILE_DIR := "user://profiles"
const PROFILE_INDEX_PATH := "user://profiles/index.cfg"
const MAX_PROFILES := 5
const C := {"bg":Color("#101820"),"panel":Color("#1b2933"),"panel2":Color("#263844"),"gold":Color("#e8bd70"),"white":Color("#f5f1e8"),"muted":Color("#a8b4bd"),"green":Color("#79a889"),"red":Color("#ce786f"),"blue":Color("#709db7")}
const STAGES := [
 {"title":"شرایط تولد","opts":["👑 لاکچری و پولدار","💵 مرفه","🙂 معمولی","😐 سخت","🔥 خیلی سخت","☠️ دارک جهنمی"],"pass":5,"games":[0,1,2,3,4]},
 {"title":"محل زندگی","opts":["🏰 ویلای لوکس","🏢 آپارتمان مدرن","🏚️ خانه قدیمی","🧱 خانه بدون امکانات"],"pass":3,"games":[5,6,7]},
 {"title":"ماشین","opts":["🏎️ ماشین خارجی","🚙 شاسی‌بلند","🚗 ماشین داخلی","🚕 پراید"],"pass":3,"games":[8,9,10]},
 {"title":"شغل","opts":["💼 مدیر شرکت","👨‍💻 برنامه‌نویس","🏪 مغازه‌دار","🧑‍🏭 کارگر","🚶 بیکار"],"pass":4,"games":[11,12,13,14]},
 {"title":"وضعیت اقتصادی","opts":["💰 ثروتمند","💳 درآمد خوب","🪙 معمولی","💸 بدهکار"],"pass":3,"games":[15,16,17]},
 {"title":"اینترنت","opts":["🚀 فیبر نوری","📶 اینترنت 5G","🌐 اینترنت معمولی","🐌 اینترنت کند","🛡️ محدودیت اینترنت برای دفاع از کشور"],"pass":4,"games":[18,19,20,21]},
 {"title":"هوش","opts":["🧠 نابغه","🤓 باهوش","🙂 معمولی","🥴 کم‌هوش","🤡 خیلی کم‌هوش"],"pass":4,"games":[22,23,24,25]},
 {"title":"قیافه","opts":["✨ بسیار جذاب","😎 خوش‌قیافه","🙂 معمولی","😐 نه‌چندان جذاب","👹 بسیار بدقیافه"],"pass":4,"games":[26,27,28,29]}
]
const GAME_NAMES := ["گاوصندوق میلیاردی","مدیریت هزینه‌های لوکس","تراز دخل‌وخرج","مدیریت بحران","پرونده کمک‌هزینه","باغ و تأسیسات هوشمند","کنترل آسانسور","تعمیرات خانه","گمرک و واردات","رانندگی و پارک دشوار","خط تولید کارخانه","جلسه هیئت‌مدیره","پیدا کردن باگ","مدیریت فروشگاه","خط تولید و شیفت کاری","مدیریت دارایی‌ها","محاسبه کسورات","خرید با بودجه محدود","اتصال شبکه","تنظیم آنتن","مدیریت بسته اینترنت","دانلود فرسایشی","معمای منطقی پیشرفته","محاسبات زمان‌دار","حافظه و الگو","هزارتوی متغیر","مسابقه مدلینگ","تقارن چهره کارتونی","استودیوی عکاسی","تغییر استایل"]
const GAME_HINTS := ["کلیدها را پیدا کن و قفل‌ها را بچرخان","هزینه‌ها را در دسته درست بگذار","عددها را مرتب کن تا تراز برابر شود","منابع را بین نیازها تقسیم کن","مدارک درست را پیدا و مرتب کن","مسیر لوله‌ها را به هم وصل کن","مسافران را به آسانسور مناسب بفرست","قطعات خراب را پیدا و جایگزین کن","محموله را با سند درست تطبیق بده","از مانع‌ها عبور کن و درست پارک کن","قطعات را به ترتیب مونتاژ کن","درخواست‌ها را اولویت‌بندی کن","مسیر داده معیوب را پیدا کن","کالاها را در قفسه درست بچین","قطعات را در زمان مناسب جابه‌جا کن","دارایی‌ها را در سبد مناسب قرار بده","کسورات را محاسبه و اصلاح کن","خرید را در بودجه نگه دار","گره‌های شبکه را به هم وصل کن","زاویه آنتن را تنظیم کن","حجم اینترنت را بین دانلودها تقسیم کن","تکه‌های فایل را بازیابی کن","الگو را کامل کن","محاسبه‌ها را حل کن","ترتیب شکل‌ها را به خاطر بسپار","راه خروج را از میان پیچ‌ها پیدا کن","لباس مناسب را انتخاب کن","اجزای چهره را تنظیم کن","نور و زاویه دوربین را تنظیم کن","استایل را مطابق درخواست تغییر بده"]
var stage := 0
var screen := "splash"
var splash_time := 0.0
var active_game := -1
var active_option := -1
var progress := 0
var target := 200
var total_actions := 0
var round_no := 1
var task_index := 0
var selected_items: Array[int] = []
var puzzle_rotation := 0
var drag_start := Vector2.ZERO
var dragging := false
var toast := ""
var toast_timer := 0.0
var current_profile := 0
var profile_names: Array[String] = ["بازیکن ۱"]
var profile_input: LineEdit
var settings := {
 "music": true, "effects": true, "volume": 80,
 "music_volume": 45, "effects_volume": 75,
 "animation_speed": 1, "difficulty": 1,
 "visual_effects": true, "theme": 0, "auto_save": true,
 "screen_shake": true, "particles": true, "haptics": true
}
var completed_choices: Array = []
var config := ConfigFile.new()
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var rng := RandomNumberGenerator.new()
var audio_clock := 0.0
var sound_ready := false
var mini_state: Dictionary = {}

func _ready() -> void:
 rng.randomize()
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(PROFILE_DIR))
 _load_profiles()
 _build_profile_input()
 _load_save()
 _setup_audio()
 get_viewport().size_changed.connect(_on_viewport_resized)
 screen = "splash"
 splash_time = 2.8
 _apply_audio_settings()
 queue_redraw()

func _process(delta: float) -> void:
 if screen == "splash":
  splash_time -= delta * _animation_multiplier()
  if splash_time <= 0.0: screen = "home"
 if toast_timer > 0.0: toast_timer -= delta * _animation_multiplier()
 if screen == "game" and active_game == 23:
  audio_clock += delta
  if audio_clock >= 1.0:
   audio_clock = 0.0
   mini_state["time_left"] = maxi(0,int(mini_state.get("time_left",30))-1)
   if int(mini_state.get("time_left",0)) == 0:
    mini_state["time_left"] = 30
    _notify("زمان این نوبت تمام شد؛ سؤال تازه رسید")
 queue_redraw()

func _draw() -> void:
 var s := get_viewport_rect().size
 draw_rect(Rect2(Vector2.ZERO,s),_background_color())
 if bool(settings.get("visual_effects",true)):
  draw_circle(Vector2(s.x*0.08,s.y*0.18),s.x*0.12,Color(0.91,0.74,0.44,0.035))
  draw_circle(Vector2(s.x*0.94,s.y*0.78),s.x*0.18,Color(0.44,0.66,0.78,0.035))
 if screen == "splash":
  _center("ایران",s.y*0.40,52,C.gold)
  _center("ساخته شده توسط",s.y*0.51,18,C.muted)
  _center("خلیل",s.y*0.56,28,C.white)
  _center("برای ورود لمس کن",s.y*0.82,14,C.muted)
  return
 if screen == "home":
  _header("ایران","یک انتخاب، یک ماجرای تازه")
  _center("زندگی را از نو انتخاب کن",s.y*0.37,27,C.white)
  _center("۸ مرحله پیش روست",s.y*0.44,17,C.muted)
  _button(Rect2(s.x*0.12,s.y*0.55,s.x*0.76,64),"شروع بازی",C.gold)
  _button(Rect2(s.x-76,32,52,46),"⚙",C.panel2)
  _button(Rect2(22,32,124,46),"پروفایل",C.panel2)
  _center("بازیکن: "+_current_profile_name(),s.y*0.90,13,C.muted)
 elif screen == "stages":
  _header("مرحله‌ها","مرحله %d از ۸" % (stage+1))
  _center(STAGES[stage]["title"],s.y*0.23,30,C.gold)
  var opts: Array = STAGES[stage]["opts"]
  var h := minf(66.0,(s.y*0.56)/opts.size())
  for i in range(opts.size()):
   var r := Rect2(s.x*0.07,s.y*0.29+i*(h+8),s.x*0.86,h)
   _button(r,String(opts[i]),C.panel2 if i != int(STAGES[stage]["pass"]) else Color("#304638"))
  _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)
 elif screen == "game":
  _draw_game(s)
 elif screen == "settings":
  _draw_settings(s)
 elif screen == "profile_select":
  _draw_profile_select(s)
 elif screen == "profile_create":
  _draw_profile_create(s)
 elif screen == "ending":
  _header("پایان مسیر","سازنده را تماشا کن")
  _center("به پایان ۸ مرحله رسیدی",s.y*0.24,25,C.gold)
  _draw_ending_art(s)
  _center("مسیرت به پایان رسید؛ اما ماجراها ادامه دارند",s.y*0.72,15,C.muted)
  _button(Rect2(s.x*0.12,s.y*0.79,s.x*0.76,58),"بازگشت به آغاز",C.gold)
 if toast_timer > 0.0:
  _button(Rect2(s.x*0.08,s.y-132,s.x*0.84,46),toast,C.panel2)

func _draw_game(s: Vector2) -> void:
 _header("بازی فرعی","مرحله %d  •  %s" % [stage+1,GAME_NAMES[active_game]])
 _center(GAME_HINTS[active_game],s.y*0.19,16,C.muted)
 _center("دور %d  |  مأموریت %d" % [round_no,task_index+1],s.y*0.25,15,C.gold)
 var ratio := clampf(float(progress)/float(target),0.0,1.0)
 var bar := Rect2(s.x*0.10,s.y*0.30,s.x*0.80,14)
 draw_rect(bar,C.panel2)
 draw_rect(Rect2(bar.position,Vector2(bar.size.x*ratio,bar.size.y)),C.green)
 _center("%s / %s" % [_fmt(progress),_fmt(target)],s.y*0.36,17,C.white)
 _draw_minigame_board(s)
 _button(Rect2(s.x*0.10,s.y*0.73,s.x*0.80,62),_action_label(),C.gold)
 _button(Rect2(20,s.y-76,140,48),"بازگشت به انتخاب",C.panel)
 _center("پیشرفت ذخیره می‌شود",s.y-18,12,C.muted)

func _draw_minigame_board(s: Vector2) -> void:
 var c:=Vector2(s.x*0.5,s.y*0.53)
 match active_game:
  0:
   draw_circle(c,95,C.panel)
   draw_arc(c,80,0,TAU,64,C.gold,3)
   for i in range(6):
    var p:=c+Vector2(cos(i*TAU/6.0),sin(i*TAU/6.0))*80
    draw_circle(p,22,C.gold if i==puzzle_rotation%6 else C.panel2)
    _center_at(str(i+1),p,16,C.bg if i==puzzle_rotation%6 else C.white)
   _center("صفحه رمز گاوصندوق",c.y+122,13,C.muted)
  1:
   _center("فهرست هزینه‌های امروز",c.y-90,15,C.muted)
   for i in range(4):
    var r:=Rect2(c.x-135+(i%2)*140,c.y-65+int(i/2)*78,125,64)
    _button(r,["سفر لوکس","رستوران","پوشاک","تفریح"][i],C.panel2)
  2:
   draw_line(Vector2(c.x-130,c.y-20),Vector2(c.x+130,c.y-20),C.gold,4)
   draw_line(Vector2(c.x,c.y-22),Vector2(c.x,c.y+48),C.gold,3)
   _center_at("درآمد",Vector2(c.x-78,c.y+12),16,C.white)
   _center_at("هزینه",Vector2(c.x+78,c.y+12),16,C.white)
   for i in range(3): _button(Rect2(c.x-145+i*100,c.y+72,88,50),str((i+1)*25+task_index),C.panel2)
  3:
   _center("اولویت منابع بحران",c.y-90,15,C.muted)
   for i in range(3):
    var x:=c.x-122+i*122
    draw_rect(Rect2(x,c.y-52,82,125),C.panel2)
    draw_rect(Rect2(x+14,c.y+25,54,25),[C.blue,C.red,C.gold][i])
    _center_at(["آب","دارو","برق"][i],Vector2(x+41,c.y-15),16,C.white)
  4:
   _center("پرونده مدارک",c.y-90,15,C.muted)
   for i in range(4):
    var x:=c.x-150+i*100
    draw_rect(Rect2(x,c.y-60,88,132),C.panel2)
    draw_rect(Rect2(x+12,c.y-42,64,7),C.gold)
    for k in range(3): draw_line(Vector2(x+12,c.y-18+k*22),Vector2(x+70,c.y-18+k*22),C.muted,2)
    _center_at(["هویت","درآمد","نشانی","درخواست"][i],Vector2(x+44,c.y+53),12,C.white)
  5:
   _center("مسیر آب را وصل کن",c.y-90,15,C.muted)
   for y in range(3):
    for x in range(3):
     var p:=Vector2(c.x-92+x*92,c.y-35+y*70)
     draw_rect(Rect2(p-Vector2(29,25),Vector2(58,50)),C.panel2)
     if posmod(x+y+puzzle_rotation,2)==0: draw_line(p-Vector2(21,0),p+Vector2(21,0),C.blue,7)
     else: draw_line(p-Vector2(0,21),p+Vector2(0,21),C.blue,7)
     draw_circle(p,6,C.gold)
  6:
   _center("پنل طبقات آسانسور",c.y-100,15,C.muted)
   for i in range(6): _button(Rect2(c.x-103+(i%2)*110,c.y-67+int(i/2)*55,90,46),"طبقه "+str(i+1),C.panel2)
   draw_rect(Rect2(c.x+125,c.y-45,35,105),C.panel)
   _center_at("↑",Vector2(c.x+142,c.y+7),24,C.gold)
  7:
   _center("قطعه معیوب را پیدا کن",c.y-90,15,C.muted)
   for i in range(4):
    var p:=Vector2(c.x-150+i*100,c.y-2)
    draw_circle(p,34,C.panel2)
    _center_at(["⚙","🔧","🔌","🔩"][i],p,26,C.gold)
    _center_at(["لوله","کلید","سیم","شیر"][i],p+Vector2(0,55),12,C.white)
  8:
   _center("اسناد محموله گمرکی",c.y-90,15,C.muted)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-50,118,110),C.panel2)
    draw_rect(Rect2(x+16,c.y-31,86,55),C.bg)
    _center_at(["بارنامه","گواهی","فاکتور"][i],Vector2(x+59,c.y+42),13,C.white)
  9:
   _center("هدایت خودرو به جای پارک",c.y-95,15,C.muted)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-55,112,145),C.panel2)
    draw_rect(Rect2(x+25,c.y-10,62,34),C.gold if i==puzzle_rotation%3 else C.blue)
    draw_circle(Vector2(x+36,c.y+25),7,C.bg)
    draw_circle(Vector2(x+76,c.y+25),7,C.bg)
    _center_at("P"+str(i+1),Vector2(x+56,c.y+63),15,C.white)
  10:
   _center("نوار نقاله کارخانه",c.y-95,15,C.muted)
   draw_line(Vector2(c.x-165,c.y+5),Vector2(c.x+165,c.y+5),C.muted,9)
   for i in range(4):
    var p:=Vector2(c.x-126+i*84,c.y+5)
    draw_rect(Rect2(p-Vector2(25,28),Vector2(50,56)),C.panel2)
    _center_at(str(i+1),p,22,C.gold)
  11:
   _center("جلسه هیئت‌مدیره",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-145,c.y-40,290,120),C.panel2)
   for i in range(4):
    var p:=Vector2(c.x-108+(i%2)*216,c.y-58+int(i/2)*155)
    draw_circle(p,20,C.gold if i==puzzle_rotation%4 else C.blue)
    _center_at(["مالی","فروش","تولید","منابع"][i],p+Vector2(0,32),12,C.white)
  12:
   _center("خط کد دارای باگ را پیدا کن",c.y-95,15,C.muted)
   for i in range(4):
    var y:=c.y-60+i*40
    draw_rect(Rect2(c.x-160,y,320,32),C.panel2 if i!=puzzle_rotation%4 else Color("#563b37"))
    _center_at("0"+str(i+1)+"  "+["if balance > 0:","amount = total / count","while stock > 0:","return result"][i],Vector2(c.x,y+1),12,C.white)
  13:
   _center("قفسه‌بندی فروشگاه",c.y-95,15,C.muted)
   for row in range(2):
    draw_line(Vector2(c.x-160,c.y-12+row*82),Vector2(c.x+160,c.y-12+row*82),C.gold,4)
    for col in range(4):
     draw_rect(Rect2(c.x-132+col*86,c.y-55+row*82,58,38),[C.blue,C.green,C.gold,C.red][posmod(col+row,4)])
  14:
   _center("جدول برنامه شیفت",c.y-95,15,C.muted)
   for i in range(3):
    var x:=c.x-150+i*105
    draw_rect(Rect2(x,c.y-55,94,130),C.panel2)
    _center_at(["صبح","عصر","شب"][i],Vector2(x+47,c.y-25),15,C.gold)
    for j in range(3): draw_rect(Rect2(x+12,c.y+j*34,70,25),C.blue if j==puzzle_rotation%3 else C.bg)
  15:
   _center("سبد دارایی و ریسک",c.y-95,15,C.muted)
   for i in range(4):
    var y:=c.y-55+i*34
    _center_at(["نقد","سهام","طلا","اوراق"][i],Vector2(c.x-120,y+9),13,C.white)
    draw_rect(Rect2(c.x-70,y,210,18),C.panel2)
    draw_rect(Rect2(c.x-70,y,210*[0.65,0.85,0.48,0.95][i],18),C.green if i==puzzle_rotation%4 else C.blue)
  16:
   _center("برگه کسورات حقوق",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-135,c.y-65,270,155),C.panel2)
   _center("حقوق پایه + مزایا",c.y-25,14,C.white)
   _center("مالیات − بیمه",c.y+12,14,C.muted)
   _center("خالص پرداختی = ؟",c.y+58,18,C.gold)
  17:
   _center("سبد خرید و بودجه",c.y-95,15,C.muted)
   for i in range(4):
    var x:=c.x-155+i*82
    draw_rect(Rect2(x,c.y-55,68,124),C.panel2)
    draw_circle(Vector2(x+34,c.y-19),17,[C.red,C.green,C.gold,C.blue][i])
    _center_at(["نان","شیر","میوه","برنج"][i],Vector2(x+34,c.y+23),12,C.white)
    _center_at(str((i+1)*15)+"k",Vector2(x+34,c.y+48),11,C.gold)
  18:
   _center("توپولوژی شبکه",c.y-95,15,C.muted)
   var nodes:=[Vector2(-125,-10),Vector2(-42,-45),Vector2(48,-45),Vector2(126,0),Vector2(0,48)]
   for i in range(nodes.size()-1): draw_line(c+nodes[i],c+nodes[i+1],C.blue,4)
   for i in range(nodes.size()):
    draw_circle(c+nodes[i],18,C.gold if i==puzzle_rotation%nodes.size() else C.panel2)
    _center_at(str(i+1),c+nodes[i],14,C.white)
  19:
   _center("زاویه آنتن؛ با کشیدن تنظیم کن",c.y-95,14,C.muted)
   draw_circle(c,74,C.panel2)
   draw_arc(c,66,0,TAU,48,C.gold,3)
   var angle:=float(puzzle_rotation%8)*PI/4.0
   draw_line(c,c+Vector2(cos(angle),sin(angle))*62,C.blue,8)
   draw_circle(c,10,C.gold)
  20:
   _center("انتخاب بسته اینترنت",c.y-95,15,C.muted)
   for i in range(3):
    var x:=c.x-150+i*150
    draw_rect(Rect2(x,c.y-60,122,135),C.panel2)
    _center_at(["روزانه","هفتگی","ماهانه"][i],Vector2(x+61,c.y-23),16,C.white)
    _center_at(["۲ گیگ","۱۰ گیگ","۳۰ گیگ"][i],Vector2(x+61,c.y+18),15,C.gold)
    _center_at("طرح "+str(i+1),Vector2(x+61,c.y+53),12,C.muted)
  21:
   _center("قطعات فایل دانلود",c.y-95,15,C.muted)
   for i in range(5):
    var x:=c.x-160+i*66
    draw_rect(Rect2(x,c.y-35,56,80),C.panel2)
    draw_rect(Rect2(x+9,c.y-20,38,30),C.blue if i==puzzle_rotation%5 else C.bg)
    _center_at("قطعه "+str(i+1),Vector2(x+28,c.y+32),10,C.white)
  22:
   _center("دنباله منطقی را کامل کن",c.y-95,15,C.muted)
   for i in range(4):
    var p:=Vector2(c.x-135+i*90,c.y+5)
    draw_circle(p,27,C.panel2)
    _center_at(["●","◆","▲","?"][i],p,22,C.gold)
   _center("ترتیب را بررسی کن",c.y+65,13,C.muted)
  23:
   _center("محاسبه زمان‌دار",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-115,c.y-60,230,50),C.panel2)
   _center("(%d + %d) × ۲" % [task_index+4,round_no+2],c.y-28,23,C.gold)
   for i in range(4): _button(Rect2(c.x-150+i*100,c.y+12,88,52),str((i+1)*8+task_index),C.panel2)
  24:
   _center("کارت‌های حافظه",c.y-95,15,C.muted)
   for i in range(6):
    var r:=Rect2(c.x-132+(i%3)*92,c.y-55+int(i/3)*75,78,62)
    draw_rect(r,C.panel2)
    _center_at("؟" if i!=puzzle_rotation%6 else ["★","◆","●","▲","✦","♥"][i],r.get_center(),24,C.gold)
  25:
   _center("هزارتو؛ مسیر خروج را بکش",c.y-95,15,C.muted)
   for row in range(4):
    for col in range(5):
     var x:=c.x-100+col*40
     var y:=c.y-55+row*40
     draw_rect(Rect2(x,y,36,36),C.panel2 if posmod(row*2+col+puzzle_rotation,4)!=0 else C.bg)
   _center("ورود  →  خروج",c.y+120,13,C.gold)
  26:
   _center("مسابقه انتخاب استایل",c.y-95,15,C.muted)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-60,116,145),C.panel2)
    draw_circle(Vector2(x+58,c.y-20),20,C.gold)
    draw_rect(Rect2(x+38,c.y+5,40,65),[C.blue,C.green,C.red][i])
    _center_at(["کلاسیک","رسمی","مدرن"][i],Vector2(x+58,c.y+84),13,C.white)
  27:
   _center("اجزای قرینه چهره",c.y-95,15,C.muted)
   draw_circle(c,70,Color("#b88d77"))
   draw_line(Vector2(c.x,c.y-70),Vector2(c.x,c.y+70),C.gold,2)
   for i in range(2):
    var x:=c.x+(-1 if i==0 else 1)*(25+((puzzle_rotation+i)%3)*5)
    draw_circle(Vector2(x,c.y-18),9,C.white)
    draw_arc(Vector2(x,c.y+12),20,0,PI,24,C.bg,3)
  28:
   _center("استودیوی عکاسی",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-145,c.y-48,290,150),C.panel2,false,4)
   draw_rect(Rect2(c.x-90,c.y-18,180,100),C.bg,false,2)
   draw_circle(c,27,C.gold)
   draw_circle(c,12,C.blue)
   draw_circle(Vector2(c.x-115,c.y-20),11,C.white)
   draw_circle(Vector2(c.x+115,c.y-20),11,C.white)
  29:
   _center("ترکیب نهایی لباس",c.y-95,15,C.muted)
   var colors:=[C.blue,C.gold,C.green,C.red]
   for i in range(4):
    var x:=c.x-150+i*100
    draw_rect(Rect2(x,c.y-55,86,130),C.panel2)
    draw_circle(Vector2(x+43,c.y-25),15,Color("#b88d77"))
    draw_rect(Rect2(x+23,c.y-5,40,60),colors[posmod(i+puzzle_rotation,4)])
    _center_at(["بالاپوش","شلوار","کفش","اکسسوری"][i],Vector2(x+43,c.y+58),11,C.white)
  _:
   _center("مأموریت اختصاصی",c.y,18,C.gold)

func _action_label() -> String:
 match active_game:
  0: return "چرخاندن رمز گاوصندوق"
  1: return "ثبت هزینه لوکس"
  2: return "تراز کردن حساب"
  3: return "تخصیص منابع بحران"
  4: return "ارسال مدرک"
  5: return "وصل کردن لوله‌ها"
  6: return "انتخاب طبقه آسانسور"
  7: return "تعویض قطعه خراب"
  8: return "تطبیق سند گمرکی"
  9: return "هدایت و پارک خودرو"
  10: return "مونتاژ قطعه بعدی"
  11: return "ثبت تصمیم جلسه"
  12: return "اصلاح خط معیوب"
  13: return "چیدن کالا در قفسه"
  14: return "تکمیل برنامه شیفت"
  15: return "تنظیم سبد دارایی"
  16: return "ثبت کسورات"
  17: return "تکمیل سبد خرید"
  18: return "اتصال گره شبکه"
  19: return "تنظیم آنتن"
  20: return "انتخاب بسته اینترنت"
  21: return "بازیابی قطعه فایل"
  22: return "تکمیل الگوی منطقی"
  23: return "ثبت پاسخ محاسبه"
  24: return "جفت‌کردن کارت‌ها"
  25: return "حرکت در هزارتو"
  26: return "انتخاب پوشش مدل"
  27: return "تنظیم تقارن"
  28: return "تنظیم نور دوربین"
  29: return "تکمیل تغییر استایل"
  _: return "انجام حرکت بعدی"

func _draw_profile_select(s:Vector2)->void:
 _header("انتخاب بازیکن","هر بازیکن ذخیره و تنظیمات جداگانه دارد")
 var h:=minf(62.0,s.y*0.075)
 var y:=s.y*0.22
 for i in range(profile_names.size()):
  var r:=Rect2(s.x*0.09,y+i*(h+10),s.x*0.82,h)
  _button(r,profile_names[i],C.panel2 if i!=current_profile else Color("#304638"))
 _button(Rect2(s.x*0.12,y+profile_names.size()*(h+12),s.x*0.76,54),"ساخت پروفایل جدید",C.gold)
 _center("تا ۵ پروفایل محلی روی همین گوشی",s.y*0.86,13,C.muted)
 _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)

func _draw_profile_create(s:Vector2)->void:
 _header("پروفایل تازه","نام دلخواه بازیکن را وارد کن")
 _center("این پروفایل پیشرفت و تنظیمات مستقل دارد",s.y*0.30,16,C.white)
 _center("نام بازیکن",s.y*0.40,15,C.gold)
 _button(Rect2(s.x*0.12,s.y*0.62,s.x*0.76,54),"ساخت و ورود",C.gold)
 _button(Rect2(20,s.y-76,116,48),"انصراف",C.panel)

func _draw_settings(s:Vector2)->void:
 _header("پروفایل و تنظیمات","تنظیمات فقط برای "+_current_profile_name())
 var labels:=[]
 labels.append("موسیقی: "+("روشن" if settings["music"] else "خاموش"))
 labels.append("افکت صوتی: "+("روشن" if settings["effects"] else "خاموش"))
 labels.append("صدای کلی: %d٪" % int(settings["volume"]))
 labels.append("موسیقی: %d٪" % int(settings["music_volume"]))
 labels.append("افکت‌ها: %d٪" % int(settings["effects_volume"]))
 labels.append("سرعت انیمیشن: "+_animation_label())
 labels.append("درجه سختی: "+_difficulty_label())
 labels.append("جلوه‌های تصویری: "+("روشن" if settings["visual_effects"] else "خاموش"))
 labels.append("لرزش صفحه: "+("روشن" if settings["screen_shake"] else "خاموش"))
 labels.append("ذرات تصویری: "+("روشن" if settings["particles"] else "خاموش"))
 labels.append("لرزش گوشی: "+("روشن" if settings["haptics"] else "خاموش"))
 labels.append("ذخیره خودکار: "+("روشن" if settings["auto_save"] else "خاموش"))
 labels.append("رنگ محیط: "+_theme_label())
 labels.append("تعویض بازیکن")
 labels.append("شروع دوباره از مرحله اول")
 labels.append("ذخیره تنظیمات و پیشرفت")
 var step:=minf(58.0,s.y*0.064)
 var row_h:=minf(47.0,s.y*0.054)
 var y0:=s.y*0.16
 for i in range(labels.size()):
  var col:=i%2
  var row:=int(i/2)
  var x:=s.x*(0.055 if col==0 else 0.515)
  _button(Rect2(x,y0+row*step,s.x*0.43,row_h),labels[i],C.panel2 if i<13 else C.panel)
 var percent:=int(round(float(stage+int(screen=="ending"))*12.5))
 _center("پیشرفت: %d٪  |  عملیات انجام‌شده: %d" % [percent,total_actions],s.y*0.78,14,C.gold)
 _center("مرحله فعلی: %d از ۸" % (stage+1),s.y*0.83,13,C.muted)
 _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)

func _load_profiles()->void:
 var meta:=ConfigFile.new()
 if meta.load(PROFILE_INDEX_PATH)==OK:
  var loaded:Variant=meta.get_value("profiles","names",["بازیکن ۱"])
  profile_names.clear()
  if loaded is Array:
   for item in loaded:
    if profile_names.size()<MAX_PROFILES:
     profile_names.append(str(item))
 if profile_names.is_empty():
  profile_names.append("بازیکن ۱")
 current_profile=clampi(int(meta.get_value("profiles","active",0)),0,profile_names.size()-1)
 _save_profiles()

func _save_profiles()->void:
 var meta:=ConfigFile.new()
 meta.set_value("profiles","names",profile_names)
 meta.set_value("profiles","active",current_profile)
 meta.save(PROFILE_INDEX_PATH)

func _profile_path(index:int)->String:
 return PROFILE_DIR+"/player_%02d.cfg" % [index+1]

func _current_profile_name()->String:
 if current_profile>=0 and current_profile<profile_names.size():
  return profile_names[current_profile]
 return "بازیکن"

func _build_profile_input()->void:
 profile_input=LineEdit.new()
 profile_input.placeholder_text="مثلاً آرش"
 profile_input.alignment=HORIZONTAL_ALIGNMENT_CENTER
 profile_input.max_length=24
 profile_input.add_theme_font_override("font",FONT_REGULAR)
 profile_input.add_theme_font_size_override("font_size",22)
 profile_input.add_theme_color_override("font_color",C.white)
 profile_input.add_theme_color_override("font_placeholder_color",C.muted)
 profile_input.visible=false
 add_child(profile_input)
 _on_viewport_resized()

func _on_viewport_resized()->void:
 if is_instance_valid(profile_input):
  var s:=get_viewport_rect().size
  profile_input.position=Vector2(s.x*0.12,s.y*0.46)
  profile_input.size=Vector2(s.x*0.76,64)
 queue_redraw()

func _create_profile()->void:
 if profile_names.size()>=MAX_PROFILES:
  _notify("حداکثر ۵ پروفایل می‌توان ساخت")
  return
 var name:=profile_input.text.strip_edges()
 if name.is_empty():
  name="بازیکن "+str(profile_names.size()+1)
 profile_names.append(name)
 current_profile=profile_names.size()-1
 _save_profiles()
 profile_input.text=""
 profile_input.visible=false
 _load_save()
 screen="home"
 _play_sfx("success")

func _select_profile(index:int)->void:
 if index<0 or index>=profile_names.size():
  return
 current_profile=index
 _save_profiles()
 _load_save()
 screen="home"
 if is_instance_valid(profile_input):
  profile_input.visible=false
 _play_sfx("tap")

func _animation_multiplier()->float:
 return [0.65,1.0,1.4][clampi(int(settings.get("animation_speed",1)),0,2)]

func _animation_label()->String:
 return ["آرام","معمولی","سریع"][clampi(int(settings.get("animation_speed",1)),0,2)]

func _difficulty_label()->String:
 return ["آسان","معمولی","سخت"][clampi(int(settings.get("difficulty",1)),0,2)]

func _theme_label()->String:
 return ["تیره","شب آبی","سبز","بنفش"][posmod(int(settings.get("theme",0)),4)]

func _background_color()->Color:
 match posmod(int(settings.get("theme",0)),4):
  1: return Color("#101c2c")
  2: return Color("#12251f")
  3: return Color("#20172b")
  _: return C.bg

func _setup_audio()->void:
 music_player=AudioStreamPlayer.new()
 music_player.name="BackgroundMusic"
 add_child(music_player)
 sfx_player=AudioStreamPlayer.new()
 sfx_player.name="SoundEffects"
 add_child(sfx_player)
 music_player.stream=_make_music_stream()
 music_player.play()
 sound_ready=true
 _apply_audio_settings()

func _make_music_stream()->AudioStreamWAV:
 var rate:=22050
 var count:=rate*6
 var data:=PackedByteArray()
 data.resize(count*2)
 var notes:=[220.0,261.63,293.66,329.63,293.66,261.63,196.0,220.0]
 for i in range(count):
  var note_index:=int(float(i)/float(rate)*1.333333)%notes.size()
  var local_time:=fmod(float(i)/float(rate),0.75)
  var envelope:=minf(1.0,local_time*12.0)*minf(1.0,(0.75-local_time)*7.0)
  var wave:=sin(TAU*notes[note_index]*float(i)/float(rate))
  var sample:=int(clampf(wave*envelope*0.055,-1.0,1.0)*32767.0)
  data.encode_s16(i*2,sample)
 var stream:=AudioStreamWAV.new()
 stream.format=AudioStreamWAV.FORMAT_16_BITS
 stream.mix_rate=rate
 stream.stereo=false
 stream.data=data
 stream.loop_mode=AudioStreamWAV.LOOP_FORWARD
 stream.loop_begin=0
 stream.loop_end=count
 return stream

func _make_sfx_stream(kind:String)->AudioStreamWAV:
 var rate:=22050
 var count:=int(rate*0.16)
 var freq:=520.0
 if kind=="success": freq=780.0
 elif kind=="error": freq=180.0
 elif kind=="move": freq=340.0
 var data:=PackedByteArray()
 data.resize(count*2)
 for i in range(count):
  var t:=float(i)/float(rate)
  var env:=pow(1.0-float(i)/float(count),2.0)
  var wave:=sin(TAU*freq*t)
  data.encode_s16(i*2,int(wave*env*0.22*32767.0))
 var stream:=AudioStreamWAV.new()
 stream.format=AudioStreamWAV.FORMAT_16_BITS
 stream.mix_rate=rate
 stream.stereo=false
 stream.data=data
 return stream

func _play_sfx(kind:String="tap")->void:
 if not sound_ready or not bool(settings.get("effects",true)):
  return
 sfx_player.stop()
 sfx_player.stream=_make_sfx_stream(kind)
 sfx_player.volume_db=linear_to_db(maxf(0.001,float(settings.get("volume",80))/100.0*float(settings.get("effects_volume",75))/100.0))
 sfx_player.play()
 if bool(settings.get("haptics",true)):
  Input.vibrate_handheld(18)

func _apply_audio_settings()->void:
 if not sound_ready:
  return
 var master:=maxf(0.001,float(settings.get("volume",80))/100.0)
 music_player.stream_paused=not bool(settings.get("music",true))
 music_player.volume_db=linear_to_db(maxf(0.001,master*float(settings.get("music_volume",45))/100.0))
 if sfx_player:
  sfx_player.volume_db=linear_to_db(maxf(0.001,master*float(settings.get("effects_volume",75))/100.0))

func _setting_action(index:int)->void:
 match index:
  0: settings["music"]=not bool(settings["music"])
  1: settings["effects"]=not bool(settings["effects"])
  2: settings["volume"]=posmod(int(settings["volume"])+10,110)
  3: settings["music_volume"]=posmod(int(settings["music_volume"])+10,110)
  4: settings["effects_volume"]=posmod(int(settings["effects_volume"])+10,110)
  5: settings["animation_speed"]=posmod(int(settings["animation_speed"])+1,3)
  6: settings["difficulty"]=posmod(int(settings["difficulty"])+1,3)
  7: settings["visual_effects"]=not bool(settings["visual_effects"])
  8: settings["screen_shake"]=not bool(settings["screen_shake"])
  9: settings["particles"]=not bool(settings["particles"])
  10: settings["haptics"]=not bool(settings["haptics"])
  11: settings["auto_save"]=not bool(settings["auto_save"])
  12: settings["theme"]=posmod(int(settings["theme"])+1,4)
  13:
   _save(true)
   screen="profile_select"
   _play_sfx("tap")
   return
  14:
   stage=0
   active_game=-1
   active_option=-1
   progress=0
   target=200
   total_actions=0
   round_no=1
   task_index=0
   completed_choices.clear()
   _save(true)
   _notify("پیشرفت این پروفایل از ابتدا آغاز شد")
  15:
   _save(true)
   _notify("پیشرفت و تنظیمات ذخیره شد")
 _apply_audio_settings()
 _play_sfx("tap")
 _save(true)

func _draw_ending_art(s:Vector2)->void:
 var c:=Vector2(s.x*0.5,s.y*0.49)
 draw_circle(c,105,Color("#263844"))
 for i in range(3):
  var x:=c.x+(i-1)*86
  var body:=Rect2(x-30,c.y-58,60,112)
  draw_rect(body,Color("#f2c637"),true,27)
  draw_circle(Vector2(x-9,c.y-16),11,C.white)
  draw_circle(Vector2(x+9,c.y-16),11,C.white)
  draw_circle(Vector2(x-9,c.y-16),4,C.bg)
  draw_circle(Vector2(x+9,c.y-16),4,C.bg)
  draw_rect(Rect2(x-26,c.y+20,52,34),Color("#3b74a3"),true,8)
  draw_line(Vector2(x-27,c.y+28),Vector2(x-48,c.y+63),C.bg,5)
  draw_line(Vector2(x+27,c.y+28),Vector2(x+48,c.y+63),C.bg,5)
 _center("مأموریت به پایان رسید!",c.y+135,16,C.gold)

func _center(t:String,y:float,size:int,color:Color) -> void:
 var w:=get_viewport_rect().size.x
 draw_string(FONT_BOLD,Vector2(0,y),t,HORIZONTAL_ALIGNMENT_CENTER,w,size,color)

func _center_at(t:String,p:Vector2,size:int,color:Color) -> void:
 draw_string(FONT_BOLD,Vector2(p.x-70,p.y+size*0.34),t,HORIZONTAL_ALIGNMENT_CENTER,140,size,color)

func _header(title:String,sub:String) -> void:
 var s:=get_viewport_rect().size
 draw_rect(Rect2(0,0,s.x,112),C.panel)
 draw_string(FONT_BOLD,Vector2(22,45),title,HORIZONTAL_ALIGNMENT_LEFT,-1,24,C.gold)
 draw_string(FONT_REGULAR,Vector2(22,78),sub,HORIZONTAL_ALIGNMENT_LEFT,-1,13,C.muted)
 _button(Rect2(s.x-72,28,52,48),"⚙",C.panel2)

func _button(r:Rect2,t:String,color:Color) -> void:
 draw_rect(r,color,true)
 draw_rect(r,Color(1,1,1,0.09),false,1.0)
 draw_string(FONT_BOLD,Vector2(r.position.x+8,r.position.y+r.size.y*0.62),t,HORIZONTAL_ALIGNMENT_CENTER,r.size.x-16,17,C.white)

func _hit(r:Rect2,p:Vector2)->bool:
 return r.has_point(p)

func _input(event:InputEvent)->void:
 if event is InputEventScreenTouch:
  var e:=event as InputEventScreenTouch
  if e.pressed:
   drag_start=e.position
   dragging=true
  else:
   if dragging: _tap(e.position,drag_start.distance_to(e.position))
   dragging=false
 elif event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
  var e:=event as InputEventMouseButton
  if e.pressed: drag_start=e.position; dragging=true
  else:
   if dragging: _tap(e.position,drag_start.distance_to(e.position))
   dragging=false
 elif event is InputEventScreenDrag and dragging:
  if drag_start.distance_to((event as InputEventScreenDrag).position)>35:
   puzzle_rotation=(puzzle_rotation+1)%5
   queue_redraw()

func _tap(p:Vector2,travel:float)->void:
 var s:=get_viewport_rect().size
 if screen=="splash":
  screen="home"
 elif screen=="home":
  if p.x>s.x-100 and p.y<120:
   screen="admin"
  elif p.y>s.y*0.5 and p.y<s.y*0.75:
   screen="stages"
 elif screen=="stages":
  if p.y>s.y-100:
   screen="home"
  elif p.x>s.x-100 and p.y<120:
   screen="admin"
  else:
   var opts:Array=STAGES[stage]["opts"]
   var h:=minf(66.0,(s.y*0.56)/opts.size())
   var idx:=int(floor((p.y-s.y*0.29)/(h+8)))
   if idx>=0 and idx<opts.size():
    if idx==int(STAGES[stage]["pass"]):
     stage+=1
     if stage>=STAGES.size():
      screen="ending"
      stage=7
     else:
      screen="stages"
     _save()
    else:
     active_option=idx
     active_game=int(STAGES[stage]["games"][idx])
     screen="game"
     _save()
 elif screen=="game":
  if p.y>s.y-105 and p.x<190:
   screen="stages"
   _save()
   return
  if p.y>s.y*0.69 and p.y<s.y*0.84:
   _advance_game()
  elif p.y>s.y*0.38 and p.y<s.y*0.69:
   if active_game in [5,9,18,19,25,27,28,29]:
    if travel>=28.0:
     puzzle_rotation=posmod(puzzle_rotation+1,8)
     _advance_game()
    else:
     _notify("برای این بازی حرکت را بکش")
   else:
    puzzle_rotation=posmod(puzzle_rotation+1,8)
    _advance_game()
  _save()
 elif screen=="admin":
  if p.y>s.y-100 and p.x<170:
   screen="home"
   return
  if not admin_unlocked:
   var key:=_admin_key_at(p,s)
   if key=="پاک":
    admin_text=admin_text.left(maxi(0,admin_text.length()-1))
   elif key=="تأیید":
    if admin_text.length()!=6:
     _notify("رمز باید ۶ رقم باشد")
    elif admin_pin=="" or admin_changing_pin:
     admin_pin=admin_text
     admin_text=""
     admin_changing_pin=false
     admin_unlocked=true
     _notify("رمز جدید ثبت شد")
     _save(true)
    elif admin_text==admin_pin:
     admin_text=""
     admin_unlocked=true
     _notify("ورود موفق")
    else:
     admin_text=""
     _notify("رمز نادرست است")
   elif key.is_valid_int() and admin_text.length()<6:
    admin_text+=key
  else:
   var row_h:=minf(48.0,s.y*0.068)
   var step:=minf(60.0,s.y*0.085)
   var y0:=s.y*0.21
   var row:=int(floor((p.y-y0)/step))
   var col:=0 if p.x<s.x*0.5 else 1
   var control:=row*2+col
   if row>=0 and row<6 and p.y<=y0+row*step+row_h:
    match control:
     0: settings["music"]=not bool(settings["music"])
     1: settings["effects"]=not bool(settings["effects"])
     2: settings["volume"]=posmod(int(settings["volume"])-1+20,100)+1
     3: settings["animation_speed"]=posmod(int(settings["animation_speed"])+1,3)
     4: settings["difficulty"]=posmod(int(settings["difficulty"])+1,3)
     5: settings["visual_effects"]=not bool(settings["visual_effects"])
     6: settings["theme"]=posmod(int(settings["theme"])+1,4)
     7: settings["auto_save"]=not bool(settings["auto_save"])
     8:
      admin_changing_pin=true
      admin_unlocked=false
      admin_text=""
     9:
      stage=0
      active_game=-1
      active_option=-1
      progress=0
      target=200
      round_no=1
      task_index=0
      total_actions=0
      completed_choices.clear()
      screen="home"
      _notify("بازی از ابتدا آغاز شد")
     10:
      _save(true)
      _notify("ذخیره شد")
     11:
      _notify("جای ویدیوی پایانی فعلاً خالی است")
   _apply_audio_settings()
   _save(true)
 elif screen=="ending":
  screen="home"
  stage=0
 queue_redraw()

func _advance_game()->void:
 total_actions+=1
 progress+=1
 var extra:=int(progress/maxi(1,target))
 if progress>=target:
  progress=0
  round_no+=1
  task_index+=1
  var difficulty_growth:float=[0.6,1.0,1.6][clampi(int(settings.get("difficulty",1)),0,2)]
  target+=maxi(50,int(float(target)*difficulty_growth))
  puzzle_rotation=rng.randi_range(0,7)
  _notify("مأموریت تازه: "+GAME_HINTS[active_game])
 elif total_actions%25==0:
  target+=int(target*0.15)
  _notify("یک بخش تازه اضافه شد؛ ادامه بده")
 else:
  _notify(["خوب پیش می‌روی","یک قطعه دیگر پیدا شد","درخواست تازه رسید","مرحله بررسی تمدید شد"][rng.randi_range(0,3)])

func _fmt(n:int)->String:
 return str(n)

func _notify(t:String)->void:
 toast=t
 toast_timer=2.2

func _save(force:bool=false)->void:
 if not force and not bool(settings.get("auto_save",true)):
  return
 config.set_value("progress","stage",stage)
 config.set_value("progress","screen",screen)
 config.set_value("progress","active_game",active_game)
 config.set_value("progress","progress",progress)
 config.set_value("progress","target",target)
 config.set_value("progress","total_actions",total_actions)
 config.set_value("progress","round_no",round_no)
 config.set_value("progress","task_index",task_index)
 config.set_value("admin","pin",admin_pin)
 config.set_value("admin","ending_video",ending_video)
 config.set_value("settings","all",settings)
 config.save(SAVE_PATH)

func _load_save()->void:
 if config.load(SAVE_PATH)!=OK:
  return
 stage=clampi(int(config.get_value("progress","stage",0)),0,7)
 active_game=int(config.get_value("progress","active_game",-1))
 progress=int(config.get_value("progress","progress",0))
 target=maxi(200,int(config.get_value("progress","target",200)))
 total_actions=int(config.get_value("progress","total_actions",0))
 round_no=maxi(1,int(config.get_value("progress","round_no",1)))
 task_index=int(config.get_value("progress","task_index",0))
 admin_pin=str(config.get_value("admin","pin",""))
 if admin_pin == "2468" or admin_pin == "1357":
  admin_pin = ""
 ending_video=str(config.get_value("admin","ending_video",""))
 var saved:Variant=config.get_value("settings","all",{})
 if saved is Dictionary:
  for key in settings.keys():
   if saved.has(key):
    settings[key]=saved[key]
 admin_unlocked=false
 _apply_audio_settings()
