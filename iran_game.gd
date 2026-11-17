extends Node2D

const FONT_REGULAR: Font = preload("res://assets/fonts/ArabicUI-Regular.ttf")
const FONT_BOLD: Font = preload("res://assets/fonts/ArabicUI-Bold.ttf")
const SAVE_PATH := "user://iran_save.cfg"
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
var shake_timer := 0.0
var particle_clock := 0.0
var sound_ready := false
var mini_state: Dictionary = {}
var tap_intervals: Array[float] = []
var last_game_tap_msec := 0
var ending_texture: Texture2D
var event_kind := ""
var event_code := 0
var event_entry := ""
var event_step := 0
var event_origin := "game"

func _ready() -> void:
 rng.randomize()
 if ResourceLoader.exists("res://assets/ending_photo.jpg"):
  ending_texture=load("res://assets/ending_photo.jpg")
 _load_save()
 _setup_audio()
 get_viewport().size_changed.connect(_on_viewport_resized)
 screen="splash"
 splash_time=3.0
 _apply_audio_settings()
 queue_redraw()

func _process(delta: float) -> void:
 if screen=="splash":
  splash_time-=delta*_animation_multiplier()
  if splash_time<=0.0:
   screen="intro"
 if toast_timer>0.0:
  toast_timer-=delta*_animation_multiplier()
 if shake_timer>0.0:
  shake_timer=maxf(0.0,shake_timer-delta)
 particle_clock+=delta
 if screen=="game" and active_game==23:
  audio_clock+=delta
  if audio_clock>=1.0:
   audio_clock=0.0
   mini_state["time_left"]=maxi(0,int(mini_state.get("time_left",30))-1)
   if int(mini_state.get("time_left",0))==0:
    mini_state["time_left"]=30
    _notify("زمان این نوبت تمام شد؛ سؤال تازه رسید")
 queue_redraw()

func _draw() -> void:
 var s:=get_viewport_rect().size
 draw_rect(Rect2(Vector2.ZERO,s),_background_color())
 if bool(settings.get("visual_effects",true)):
  draw_circle(Vector2(s.x*0.08,s.y*0.18),s.x*0.12,Color(0.91,0.74,0.44,0.035))
  draw_circle(Vector2(s.x*0.94,s.y*0.78),s.x*0.18,Color(0.44,0.66,0.78,0.035))
 var shake:=Vector2.ZERO
 if shake_timer>0.0 and bool(settings.get("screen_shake",true)):
  shake=Vector2(rng.randf_range(-4.0,4.0),rng.randf_range(-3.0,3.0))
 draw_set_transform(shake,0.0,Vector2.ONE)
 if bool(settings.get("particles",true)):
  for i in range(18):
   var px:=fposmod(float(i*73)+particle_clock*19.0,s.x)
   var py:=fposmod(float(i*117)+particle_clock*11.0,s.y)
   draw_circle(Vector2(px,py),1.5+float(i%3),Color(0.91,0.74,0.44,0.12))
 if screen=="splash":
  var c:=Vector2(s.x*0.5,s.y*0.34)
  draw_circle(c,76,C.panel)
  draw_arc(c,68,0,TAU,72,C.gold,3)
  draw_rect(Rect2(c.x-42,c.y-24,84,16),Color("#23945b"))
  draw_rect(Rect2(c.x-42,c.y-8,84,16),C.white)
  draw_rect(Rect2(c.x-42,c.y+8,84,16),Color("#d64a4a"))
  _center("ایران",s.y*0.55,50,C.gold)
  _center("ساخته شده توسط",s.y*0.64,18,C.muted)
  _center("خلیل",s.y*0.70,27,C.white)
  _center("یک تجربهٔ آفلاین",s.y*0.86,14,C.muted)
 elif screen=="intro":
  _draw_intro(s)
 elif screen=="home":
  _header("ایران","یک زندگی، هزار انتخاب")
  _draw_home_art(s)
  _center("زندگی را از نو انتخاب کن",s.y*0.53,25,C.white)
  _center("۸ انتخاب تا پایان مسیر",s.y*0.58,16,C.muted)
  _button(Rect2(s.x*0.10,s.y*0.64,s.x*0.80,66),"ادامهٔ زندگی" if active_game>=0 else "شروع بازی",C.gold)
  _center("هر انتخاب، بخشی از داستان توست",s.y*0.79,14,C.muted)
 elif screen=="stages":
  _header("مسیر زندگی","مرحله %d از ۸" % (stage+1))
  var bar:=Rect2(s.x*0.09,s.y*0.145,s.x*0.82,8)
  draw_rect(bar,C.panel2)
  draw_rect(Rect2(bar.position,Vector2(bar.size.x*float(stage)/8.0,bar.size.y)),C.gold)
  _center(STAGES[stage]["title"],s.y*0.235,29,C.gold)
  var opts:Array=STAGES[stage]["opts"]
  var h:=minf(66.0,(s.y*0.55)/opts.size())
  var y0:=s.y*0.29
  for i in range(opts.size()):
   var r:=Rect2(s.x*0.07,y0+i*(h+8),s.x*0.86,h)
   var color:=Color("#304638") if i==int(STAGES[stage]["pass"]) else C.panel2
   _button(r,String(opts[i]),color)
  _center("یکی از شرایط زندگی را انتخاب کن",s.y*0.86,13,C.muted)
  _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)
 elif screen=="game":
  _draw_game(s)
 elif screen=="settings":
  _draw_settings(s)
 elif screen=="event":
  _draw_event(s)
 elif screen=="ending":
  _header("پایان مسیر","این مسیر را تو ساختی")
  _center("تبریک! با شرایطی که خودت انتخاب کردی، در ایران به دنیا آمدی.",s.y*0.22,17,C.gold)
  _draw_ending_art(s)
  _center("حالا ادامهٔ داستان در دست توست.",s.y*0.72,16,C.white)
  _center("امیدوارم روزهایت پر از شادی، آرامش و اتفاق‌های روشن باشد.",s.y*0.755,13,C.muted)
  _button(Rect2(s.x*0.10,s.y*0.82,s.x*0.80,56),"بازگشت به آغاز",C.gold)
 if toast_timer>0.0:
  _button(Rect2(s.x*0.08,s.y-132,s.x*0.84,46),toast,C.panel2)
 draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)

func _draw_intro(s:Vector2)->void:
 var card:=Rect2(s.x*0.07,s.y*0.20,s.x*0.86,s.y*0.57)
 draw_rect(card,C.panel,true)
 draw_rect(card.grow(1),Color(1,1,1,0.10),false,2)
 draw_circle(Vector2(s.x*0.5,s.y*0.31),45,Color("#304638"))
 draw_arc(Vector2(s.x*0.5,s.y*0.31),43,0,TAU,64,C.gold,2)
 _center("الان توی ایران به دنیا اومدی!",s.y*0.43,23,C.gold)
 _center("قراره محیطی رو انتخاب کنی",s.y*0.51,20,C.white)
 _center("که توش عمرت رو",s.y*0.565,19,C.white)
 _center("تلف کردن",s.y*0.615,18,C.muted)
 draw_line(Vector2(s.x*0.43,s.y*0.606),Vector2(s.x*0.57,s.y*0.606),C.red,3)
 _center("زندگی کردن",s.y*0.665,22,C.green)
 _button(Rect2(s.x*0.10,s.y*0.82,s.x*0.80,58),"ورود به زندگی",C.gold)

func _draw_home_art(s:Vector2)->void:
 var c:=Vector2(s.x*0.5,s.y*0.355)
 draw_circle(c,104,C.panel)
 draw_arc(c,94,0,TAU,80,C.gold,3)
 draw_circle(c,44,Color("#304638"))
 draw_arc(c,42,0,TAU,64,C.white,2)
 for i in range(8):
  var angle:float=-PI/2.0+float(i)*TAU/8.0
  var p:=c+Vector2(cos(angle),sin(angle))*132.0
  draw_line(c+Vector2(cos(angle),sin(angle))*108.0,p,C.blue,2)
  draw_circle(p,11,C.gold if i<stage else C.panel2)
 _center("ایران",c.y+8,24,C.white)

func _draw_game(s: Vector2) -> void:
 _header("بازی فرعی","مرحله %d  •  %s" % [stage+1,GAME_NAMES[active_game]])
 _center(GAME_HINTS[active_game],s.y*0.19,16,C.muted)
 _center("دور %d  |  مأموریت %d" % [round_no,task_index+1],s.y*0.25,15,C.gold)
 var ratio:=clampf(float(progress)/float(maxi(1,target)),0.0,1.0)
 var bar:=Rect2(s.x*0.10,s.y*0.30,s.x*0.80,14)
 draw_rect(bar,C.panel2)
 draw_rect(Rect2(bar.position,Vector2(bar.size.x*ratio,bar.size.y)),C.green)
 _center("%s / %s" % [_fmt(progress),_fmt(target)],s.y*0.36,17,C.white)
 _draw_minigame_board(s)
 _center(_action_label(),s.y*0.77,14,C.gold)
 _button(Rect2(20,s.y-76,140,48),"بازگشت به انتخاب",C.panel)
 _center("عملیات ثبت‌شده: %d" % total_actions,s.y-18,12,C.muted)
 if active_game==23:
  _center("زمان باقی‌مانده: %d ثانیه" % int(mini_state.get("time_left",30)),s.y*0.40,14,C.gold)

func _draw_minigame_board(s: Vector2) -> void:
 var c:=Vector2(s.x*0.5,s.y*0.53)
 match active_game:
  0:
   var expected_sector:=posmod(task_index+round_no+int(mini_state.get("step",0))*2,6)
   var target_slot:=posmod(expected_sector-2,6)
   draw_circle(c,95,C.panel)
   draw_arc(c,80,0,TAU,64,C.gold,3)
   for i in range(6):
    var p:=c+Vector2(cos(i*TAU/6.0),sin(i*TAU/6.0))*80
    draw_circle(p,22,C.green if i==target_slot else C.panel2)
    _center_at(str(i+1),p,16,C.bg if i==target_slot else C.white)
   _center("رمز بعدی: خانهٔ %d" % (target_slot+1),c.y+122,14,C.gold)
  1:
   _center("فهرست هزینه‌های امروز",c.y-90,15,C.muted)
   _center("بودجه: %d  |  مصرف‌شده: %d" % [int(mini_state.get("budget",100)),int(mini_state.get("spent",0))],c.y-67,12,C.gold)
   for i in range(4):
    var r:=Rect2(c.x-135+(i%2)*140,c.y-65+int(i/2)*78,125,64)
    _button(r,["سفر لوکس","رستوران","پوشاک","تفریح"][i],C.panel2)
  2:
   var expected_balance:=posmod(task_index+round_no+int(mini_state.get("turn",0)),3)
   _center("تراز دخل‌وخرج",c.y-90,15,C.muted)
   _center("مقدار لازم برای تراز: %d" % ((expected_balance+1)*25+task_index),c.y-61,13,C.gold)
   draw_line(Vector2(c.x-130,c.y-10),Vector2(c.x+130,c.y-10),C.gold,4)
   draw_line(Vector2(c.x,c.y-12),Vector2(c.x,c.y+48),C.gold,3)
   _center_at("درآمد",Vector2(c.x-78,c.y+18),15,C.white)
   _center_at("هزینه",Vector2(c.x+78,c.y+18),15,C.white)
   for i in range(3):
    var option_value:=(i+1)*25+task_index
    _button(Rect2(c.x-145+i*100,c.y+72,88,50),str(option_value),C.green if i==expected_balance else C.panel2)
  3:
   var priorities:Array=["آب","دارو","برق"]
   var urgent:=posmod(task_index+int(mini_state.get("turn",0)),3)
   _center("اولویت منابع بحران",c.y-90,15,C.muted)
   _center("نیاز فوری: "+priorities[urgent],c.y-62,14,C.gold)
   for i in range(3):
    var x:=c.x-122+i*122
    draw_rect(Rect2(x,c.y-40,82,125),C.green if i==urgent else C.panel2)
    draw_rect(Rect2(x+14,c.y+30,54,25),[C.blue,C.red,C.gold][i])
    _center_at(priorities[i],Vector2(x+41,c.y-3),16,C.white)
  4:
   var documents:Array=["هویت","درآمد","نشانی","درخواست"]
   var required:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("پرونده مدارک",c.y-90,15,C.muted)
   _center("مدرک موردنیاز: "+documents[required],c.y-62,14,C.gold)
   for i in range(4):
    var x:=c.x-150+i*100
    draw_rect(Rect2(x,c.y-48,88,132),C.green if i==required else C.panel2)
    draw_rect(Rect2(x+12,c.y-30,64,7),C.gold)
    for k in range(3): draw_line(Vector2(x+12,c.y-6+k*22),Vector2(x+70,c.y-6+k*22),C.muted,2)
    _center_at(documents[i],Vector2(x+44,c.y+65),12,C.white)
  5:
   _center("مسیر ورودی تا خروجی آب را کامل کن",c.y-90,14,C.muted)
   var pipe_tiles:Array=mini_state.get("pipe_tiles",[])
   var pipe_row:=int(mini_state.get("pipe_row",1))
   for y in range(3):
    for x in range(3):
     var index:=y*3+x
     var p:=Vector2(c.x-92+x*92,c.y-35+y*70)
     var orientation:=int(pipe_tiles[index]) if pipe_tiles.size()==9 else 0
     draw_rect(Rect2(p-Vector2(29,25),Vector2(58,50)),C.panel2)
     if orientation==0:
      draw_line(p-Vector2(22,0),p+Vector2(22,0),C.blue,8)
     else:
      draw_line(p-Vector2(0,22),p+Vector2(0,22),C.blue,8)
     draw_circle(p,6,C.gold)
   draw_circle(Vector2(c.x-126,c.y-35+pipe_row*70),10,C.green)
   draw_circle(Vector2(c.x+126,c.y-35+pipe_row*70),10,C.gold)
  6:
   _center("مقصد مسافر: طبقهٔ %d" % (posmod(task_index+int(mini_state.get("turn",0))+2,6)+1),c.y-100,15,C.muted)
   for i in range(6): _button(Rect2(c.x-103+(i%2)*110,c.y-67+int(i/2)*55,90,46),"طبقه "+str(i+1),C.panel2)
   draw_rect(Rect2(c.x+125,c.y-45,35,105),C.panel)
   _center_at("↑",Vector2(c.x+142,c.y+7),24,C.gold)
  7:
   _center("قطعه معیوب را پیدا کن",c.y-90,15,C.muted)
   for i in range(4):
    var p:=Vector2(c.x-150+i*100,c.y-2)
    var faulty:=i==posmod(task_index+round_no,4)
    draw_circle(p,34,Color("#563b37") if faulty else C.panel2)
    _center_at(["⚙","🔧","🔌","🔩"][i],p,26,C.gold)
    _center_at(["لوله","کلید","سیم","شیر"][i],p+Vector2(0,55),12,C.white)
  8:
   var papers:Array=["بارنامه","گواهی","فاکتور"]
   var required_paper:=posmod(task_index+int(mini_state.get("turn",0)),3)
   _center("اسناد محموله گمرکی",c.y-90,15,C.muted)
   _center("سند درخواستی: "+papers[required_paper],c.y-62,14,C.gold)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-45,118,110),C.green if i==required_paper else C.panel2)
    draw_rect(Rect2(x+16,c.y-26,86,55),C.bg)
    _center_at(papers[i],Vector2(x+59,c.y+48),13,C.white)
  9:
   var directions:Array=["راست","چپ","پایین","بالا"]
   var wanted:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("هدایت خودرو به جای پارک",c.y-95,15,C.muted)
   _center("مسیر بعدی: "+directions[wanted],c.y-67,14,C.gold)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-45,112,145),C.panel2)
    draw_rect(Rect2(x+25,c.y,62,34),C.gold if i==puzzle_rotation%3 else C.blue)
    draw_circle(Vector2(x+36,c.y+35),7,C.bg)
    draw_circle(Vector2(x+76,c.y+35),7,C.bg)
    _center_at("پارک "+str(i+1),Vector2(x+56,c.y+72),13,C.white)
   _center("برای فرمان، انگشت را در جهت خواسته‌شده بکش",c.y+120,12,C.muted)
  10:
   var next_station:=posmod(int(mini_state.get("turn",0))+task_index,4)
   _center("نوار نقاله کارخانه",c.y-95,15,C.muted)
   _center("ایستگاه بعدی: %d" % (next_station+1),c.y-67,14,C.gold)
   draw_line(Vector2(c.x-165,c.y+5),Vector2(c.x+165,c.y+5),C.muted,9)
   for i in range(4):
    var p:=Vector2(c.x-126+i*84,c.y+5)
    draw_rect(Rect2(p-Vector2(25,28),Vector2(50,56)),C.green if i==next_station else C.panel2)
    _center_at(str(i+1),p,22,C.gold)
  11:
   var proposal_labels:Array=["مالی","فروش","تولید","منابع"]
   var expected_proposal:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("جلسه هیئت‌مدیره؛ اولویت: "+proposal_labels[expected_proposal],c.y-95,13,C.muted)
   draw_rect(Rect2(c.x-145,c.y-40,290,120),C.panel2)
   for i in range(4):
    var p:=Vector2(c.x-108+(i%2)*216,c.y-58+int(i/2)*155)
    draw_circle(p,20,C.gold if i==puzzle_rotation%4 else C.blue)
    _center_at(["مالی","فروش","تولید","منابع"][i],p+Vector2(0,32),12,C.white)
  12:
   _center("خط کد دارای باگ را پیدا کن",c.y-95,15,C.muted)
   for i in range(4):
    var y:=c.y-60+i*40
    draw_rect(Rect2(c.x-160,y,320,32),Color("#563b37") if i==posmod(task_index+round_no,4) else C.panel2)
    _center_at("0"+str(i+1)+"  "+["if balance > 0:","amount = total / count","while stock > 0:","return result"][i],Vector2(c.x,y+1),12,C.white)
  13:
   var shelves:Array=["آبی","سبز","زرد","قرمز"]
   var target_shelf:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("قفسه‌بندی فروشگاه",c.y-95,15,C.muted)
   _center("کالا باید در قفسهٔ "+shelves[target_shelf]+" قرار بگیرد",c.y-67,13,C.gold)
   var shelf_colors:Array=[C.blue,C.green,C.gold,C.red]
   for row in range(2):
    draw_line(Vector2(c.x-160,c.y-12+row*82),Vector2(c.x+160,c.y-12+row*82),C.gold,4)
    for col in range(4):
     var target:=col==target_shelf
     draw_rect(Rect2(c.x-132+col*86,c.y-55+row*82,58,38),shelf_colors[col] if target else Color(shelf_colors[col],0.38))
  14:
   var shifts:Array=["صبح","عصر","شب"]
   var wanted_shift:=posmod(task_index+int(mini_state.get("turn",0)),3)
   _center("جدول برنامه شیفت",c.y-95,15,C.muted)
   _center("شیفت موردنیاز: "+shifts[wanted_shift],c.y-67,14,C.gold)
   for i in range(3):
    var x:=c.x-150+i*105
    draw_rect(Rect2(x,c.y-45,94,130),C.panel2)
    _center_at(shifts[i],Vector2(x+47,c.y-15),15,C.gold)
    for j in range(3):
     draw_rect(Rect2(x+12,c.y+10+j*30,70,22),C.green if j==wanted_shift else C.blue if j==puzzle_rotation%3 else C.bg)
  15:
   var expected_asset:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("سبد دارایی؛ گزینهٔ کم‌ریسک/پربازده را انتخاب کن",c.y-95,13,C.muted)
   for i in range(4):
    var y:=c.y-55+i*34
    _center_at(["نقد","سهام","طلا","اوراق"][i],Vector2(c.x-120,y+9),13,C.white)
    draw_rect(Rect2(c.x-70,y,210,18),C.panel2)
    draw_rect(Rect2(c.x-70,y,210*[0.65,0.85,0.48,0.95][i],18),C.green if i==expected_asset else C.blue)
   _center("سبد پیشنهادی: "+["نقد","سهام","طلا","اوراق"][expected_asset],c.y+105,13,C.gold)
  16:
   var gross:=1000+task_index*20
   _center("برگه کسورات حقوق",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-135,c.y-65,270,115),C.panel2)
   _center("حقوق و مزایا: %d" % gross,c.y-38,14,C.white)
   _center("مالیات و بیمه: ۲۰٪",c.y-8,14,C.muted)
   _center("خالص پرداختی = ؟",c.y+18,17,C.gold)
   for i in range(4):
    _button(Rect2(c.x-155+i*80,c.y+65,70,42),str(gross-300+i*100),C.panel2)
  17:
   _center("سبد خرید و بودجه",c.y-95,15,C.muted)
   _center("بودجه: %d  |  خرج‌شده: %d" % [int(mini_state.get("budget",120)),int(mini_state.get("spent",0))],c.y-67,13,C.gold)
   for i in range(4):
    var x:=c.x-155+i*82
    draw_rect(Rect2(x,c.y-55,68,124),C.panel2)
    draw_circle(Vector2(x+34,c.y-19),17,[C.red,C.green,C.gold,C.blue][i])
    _center_at(["نان","شیر","میوه","برنج"][i],Vector2(x+34,c.y+23),12,C.white)
    _center_at(str((i+1)*15)+"k",Vector2(x+34,c.y+48),11,C.gold)
  18:
   var nodes:Array=[Vector2(-125,-10),Vector2(-42,-45),Vector2(48,-45),Vector2(126,0),Vector2(0,48)]
   var next_node:=posmod(int(mini_state.get("turn",0)),5)
   _center("توپولوژی شبکه",c.y-95,15,C.muted)
   _center("گره بعدی برای اتصال: %d" % (next_node+1),c.y-67,14,C.gold)
   for i in range(nodes.size()-1): draw_line(c+nodes[i],c+nodes[i+1],C.blue,4)
   for i in range(nodes.size()):
    draw_circle(c+nodes[i],18,C.green if i==next_node else C.panel2)
    _center_at(str(i+1),c+nodes[i],14,C.white)
  19:
   var target_angle:=float(posmod(task_index+int(mini_state.get("turn",0)),8))*PI/4.0
   _center("زاویه آنتن؛ با کشیدن تنظیم کن",c.y-95,14,C.muted)
   _center("جهت هدف: %d درجه" % int(rad_to_deg(target_angle)),c.y-68,13,C.gold)
   draw_circle(c,74,C.panel2)
   draw_arc(c,66,0,TAU,48,C.gold,3)
   draw_line(c,c+Vector2(cos(target_angle),sin(target_angle))*68,C.green,5)
   draw_line(c,c+Vector2(cos(float(puzzle_rotation%8)*PI/4.0),sin(float(puzzle_rotation%8)*PI/4.0))*48,C.blue,8)
   draw_circle(c,10,C.gold)
  20:
   var packages:Array=["روزانه","هفتگی","ماهانه"]
   var wanted_package:=posmod(task_index+int(mini_state.get("turn",0))+1,3)
   _center("انتخاب بسته اینترنت",c.y-95,15,C.muted)
   _center("مصرف پیش‌بینی‌شده: "+["کم","متوسط","زیاد"][wanted_package]+"  |  بسته پیشنهادی: "+packages[wanted_package],c.y-67,12,C.gold)
   for i in range(3):
    var x:=c.x-150+i*150
    draw_rect(Rect2(x,c.y-38,122,135),C.green if i==wanted_package else C.panel2)
    _center_at(packages[i],Vector2(x+61,c.y-1),16,C.white)
    _center_at(["۲ گیگ","۱۰ گیگ","۳۰ گیگ"][i],Vector2(x+61,c.y+40),15,C.gold)
    _center_at("طرح "+str(i+1),Vector2(x+61,c.y+75),12,C.muted)
  21:
   var next_piece:=posmod(int(mini_state.get("turn",0)),5)
   _center("قطعات فایل دانلود",c.y-95,15,C.muted)
   _center("قطعهٔ بعدی: %d از ۵" % (next_piece+1),c.y-67,14,C.gold)
   for i in range(5):
    var x:=c.x-160+i*66
    draw_rect(Rect2(x,c.y-32,56,80),C.green if i==next_piece else C.panel2)
    draw_rect(Rect2(x+9,c.y-17,38,30),C.blue if i==next_piece else C.bg)
    _center_at("قطعه "+str(i+1),Vector2(x+28,c.y+35),10,C.white)
  22:
   var symbols:Array=["●","◆","▲","■"]
   var seed:=posmod(task_index+round_no+int(mini_state.get("turn",0)),4)
   _center("دنباله منطقی را کامل کن",c.y-95,15,C.muted)
   _center("الگو: %s  %s  %s  %s  ?" % [symbols[seed],symbols[posmod(seed+1,4)],symbols[posmod(seed+2,4)],symbols[seed]],c.y-55,19,C.gold)
   _center("شکل بعدی را از گزینه‌ها انتخاب کن",c.y+2,13,C.muted)
   for i in range(4):
    var p:=Vector2(c.x-135+i*90,c.y+54)
    draw_circle(p,28,C.green if i==posmod(seed+1,4) else C.panel2)
    _center_at(symbols[i],p,22,C.gold)
  23:
   var left_value:=task_index+int(mini_state.get("turn",0))+4
   var right_value:=round_no+posmod(int(mini_state.get("turn",0)),3)+2
   var answer_value:=(left_value+right_value)*2
   _center("محاسبه زمان‌دار",c.y-95,15,C.muted)
   draw_rect(Rect2(c.x-115,c.y-60,230,50),C.panel2)
   _center("(%d + %d) × ۲" % [left_value,right_value],c.y-28,23,C.gold)
   var answers:Array=[answer_value-6,answer_value-3,answer_value,answer_value+5]
   for i in range(4):
    _button(Rect2(c.x-150+i*100,c.y+12,88,52),str(answers[i]),C.panel2)
  24:
   _center("کارت‌های حافظه",c.y-95,15,C.muted)
   var memory_symbols:=["★","★","◆","◆","●","●"]
   var shown_cards:Array=mini_state.get("memory_found",[])
   for i in range(6):
    var r:=Rect2(c.x-132+(i%3)*92,c.y-55+int(i/3)*75,78,62)
    draw_rect(r,C.green if i in shown_cards or i==int(mini_state.get("memory_first",-1)) else C.panel2)
    var face:String=str(memory_symbols[i]) if i in shown_cards or i==int(mini_state.get("memory_first",-1)) else "؟"
    _center_at(face,r.get_center(),24,C.gold)
  25:
   _center("هزارتو؛ راه خروج را با حرکت‌های پی‌درپی پیدا کن",c.y-95,13,C.muted)
   var maze_path:Array=[0,5,6,11,12,17,18,19]
   for row in range(4):
    for col in range(5):
     var pos:=row*5+col
     var x:=c.x-100+col*40
     var y:=c.y-55+row*40
     var open:=pos in maze_path
     draw_rect(Rect2(x,y,36,36),C.panel2 if open else Color("#111a20"))
     if pos==0: _center_at("ورود",Vector2(x+18,y+18),9,C.green)
     elif pos==19: _center_at("خروج",Vector2(x+18,y+18),9,C.gold)
     if pos==int(mini_state.get("maze_pos",0)):
      draw_circle(Vector2(x+18,y+18),10,C.white)
   _center("با کشیدن انگشت حرکت کن",c.y+120,13,C.gold)
  26:
   var style_labels:Array=["کلاسیک","رسمی","مدرن"]
   var requested_style:=posmod(task_index+round_no+int(mini_state.get("turn",0)),3)
   _center("درخواست مشتری: "+style_labels[requested_style],c.y-95,15,C.gold)
   for i in range(3):
    var x:=c.x-145+i*145
    draw_rect(Rect2(x,c.y-60,116,145),C.panel2)
    draw_circle(Vector2(x+58,c.y-20),20,C.gold)
    draw_rect(Rect2(x+38,c.y+5,40,65),[C.blue,C.green,C.red][i])
    _center_at(style_labels[i],Vector2(x+58,c.y+84),13,C.white)
  27:
   var required_direction:="راست" if posmod(task_index+int(mini_state.get("turn",0)),2)==0 else "چپ"
   _center("اجزای قرینه چهره",c.y-95,15,C.muted)
   _center("حرکت اصلاحی: به سمت "+required_direction,c.y-67,13,C.gold)
   draw_circle(c,70,Color("#b88d77"))
   draw_line(Vector2(c.x,c.y-70),Vector2(c.x,c.y+70),C.gold,2)
   for i in range(2):
    var x:=c.x+(-1 if i==0 else 1)*(25+((puzzle_rotation+i)%3)*5)
    draw_circle(Vector2(x,c.y-18),9,C.white)
    draw_arc(Vector2(x,c.y+12),20,0,PI,24,C.bg,3)
   _center("جزئیات دو سوی چهره را هماهنگ کن",c.y+100,13,C.muted)
  28:
   _center("استودیوی عکاسی؛ نور را مطابق نمونه تنظیم کن",c.y-95,14,C.muted)
   var light_level:=int(mini_state.get("light",1))
   var light_target:=int(mini_state.get("light_target",1))
   draw_rect(Rect2(c.x-145,c.y-48,290,150),C.panel2,false,4)
   draw_rect(Rect2(c.x-90,c.y-18,180,100),C.bg,false,2)
   draw_circle(c,27,Color(0.91,0.74,0.44,0.25+float(light_level)*0.15))
   draw_circle(c,12,C.blue)
   draw_circle(Vector2(c.x-115,c.y-20),11,C.white)
   draw_circle(Vector2(c.x+115,c.y-20),11,C.white)
   _center("نور فعلی: %d   |   نور نمونه: %d" % [light_level,light_target],c.y+125,13,C.gold)
   _center("چپ: کاهش نور     راست: افزایش نور",c.y+150,12,C.muted)
  29:
   var outfit_parts:Array=["بالاپوش","شلوار","کفش","اکسسوری"]
   var required_part:=posmod(task_index+int(mini_state.get("turn",0)),4)
   _center("ترکیب نهایی لباس",c.y-95,15,C.muted)
   _center("جزئیات درخواستی: "+outfit_parts[required_part],c.y-67,14,C.gold)
   var colors:Array=[C.blue,C.gold,C.green,C.red]
   for i in range(4):
    var x:=c.x-150+i*100
    draw_rect(Rect2(x,c.y-45,86,120),C.green if i==required_part else C.panel2)
    draw_circle(Vector2(x+43,c.y-15),15,Color("#b88d77"))
    draw_rect(Rect2(x+23,c.y+5,40,48),colors[posmod(i+puzzle_rotation,4)])
    _center_at(outfit_parts[i],Vector2(x+43,c.y+63),11,C.white)
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



func _draw_settings(s:Vector2)->void:
 _header("تنظیمات بازی","تغییرات فقط روی همین گوشی ذخیره می‌شوند")
 var labels:Array=[]
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
 labels.append("شروع دوباره از مرحله اول")
 labels.append("ذخیره تنظیمات و پیشرفت")
 var row_h:=minf(48.0,s.y*0.037)
 var step:=row_h+6.0
 var y0:=s.y*0.145
 for i in range(labels.size()):
  var color:=C.panel2 if i<13 else (Color("#563b37") if i==13 else Color("#304638"))
  _button(Rect2(s.x*0.08,y0+i*step,s.x*0.84,row_h),labels[i],color)
 var percent:=int(round(float(stage+(1 if screen=="ending" else 0))*12.5))
 _center("پیشرفت مسیر: %d٪  |  عملیات: %d" % [percent,total_actions],s.y*0.89,13,C.gold)
 _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)

func _on_viewport_resized()->void:
 queue_redraw()

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
   stage=0
   active_game=-1
   active_option=-1
   progress=0
   target=200
   total_actions=0
   round_no=1
   task_index=0
   mini_state.clear()
   completed_choices.clear()
   _save(true)
   _notify("مسیر بازی از مرحلهٔ اول آغاز شد")
  14:
   _save(true)
   _notify("تنظیمات و پیشرفت ذخیره شدند")
 _apply_audio_settings()
 _play_sfx("tap")
 _save(true)

func _draw_ending_art(s:Vector2)->void:
 var c:=Vector2(s.x*0.5,s.y*0.49)
 if ending_texture!=null:
  var area:=Rect2(s.x*0.10,s.y*0.30,s.x*0.80,s.y*0.39)
  var tex_size:=Vector2(ending_texture.get_width(),ending_texture.get_height())
  var scale_factor:=minf(area.size.x/tex_size.x,area.size.y/tex_size.y)
  var draw_size:=tex_size*scale_factor
  var dest:=Rect2(area.get_center()-draw_size*0.5,draw_size)
  draw_rect(dest.grow(7),C.gold,true)
  draw_texture_rect(ending_texture,dest,false)
  return
 draw_circle(c,105,Color("#263844"))
 for i in range(3):
  var x:=c.x+(i-1)*86
  draw_rect(Rect2(x-30,c.y-28,60,88),Color("#f2c637"),true)
  draw_circle(Vector2(x,c.y-28),30,Color("#f2c637"))
  draw_circle(Vector2(x,c.y+60),30,Color("#f2c637"))
  draw_circle(Vector2(x,c.y-18),17,C.white)
  draw_circle(Vector2(x,c.y-18),7,C.bg)
  draw_rect(Rect2(x-25,c.y+32,50,24),Color("#3b74a3"),true)
  draw_line(Vector2(x-27,c.y+44),Vector2(x-48,c.y+70),C.bg,5)
  draw_line(Vector2(x+27,c.y+44),Vector2(x+48,c.y+70),C.bg,5)
 _center("مأموریت به پایان رسید!",c.y+135,16,C.gold)

func _center(t:String,y:float,size:int,color:Color) -> void:
 var w:=get_viewport_rect().size.x
 draw_string(FONT_BOLD,Vector2(0,y),t,HORIZONTAL_ALIGNMENT_CENTER,w,size,color)

func _center_at(t:String,p:Vector2,size:int,color:Color) -> void:
 draw_string(FONT_BOLD,Vector2(p.x-70,p.y+size*0.34),t,HORIZONTAL_ALIGNMENT_CENTER,140,size,color)

func _header(title:String,sub:String) -> void:
 var s:=get_viewport_rect().size
 draw_rect(Rect2(0,0,s.x,112),C.panel)
 draw_rect(Rect2(0,108,s.x,4),C.gold)
 draw_string(FONT_BOLD,Vector2(20,45),title,HORIZONTAL_ALIGNMENT_RIGHT,s.x-110,24,C.gold)
 draw_string(FONT_REGULAR,Vector2(20,78),sub,HORIZONTAL_ALIGNMENT_RIGHT,s.x-110,13,C.muted)
 if screen!="settings" and screen!="ending":
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
 _play_sfx("tap")
 var s:=get_viewport_rect().size
 if screen=="splash":
  screen="intro"
 elif screen=="intro":
  if p.y>=s.y*0.74:
   screen="home"
 elif screen=="home":
  if p.x>s.x-105 and p.y<120:
   screen="settings"
  elif p.y>=s.y*0.59 and p.y<=s.y*0.77:
   screen="game" if active_game>=0 else "stages"
 elif screen=="settings":
  if p.y>s.y-105 and p.x<180:
   screen="home"
  else:
   var row_h:=minf(48.0,s.y*0.037)
   var step:=row_h+6.0
   var y0:=s.y*0.145
   var row:=int(floor((p.y-y0)/step))
   if row>=0 and row<15 and p.y<=y0+row*step+row_h:
    _setting_action(row)
 elif screen=="stages":
  if p.y>s.y-100 and p.x<170:
   screen="home"
  elif p.x>s.x-100 and p.y<120:
   screen="settings"
  else:
   var opts:Array=STAGES[stage]["opts"]
   var h:=minf(66.0,(s.y*0.55)/opts.size())
   var idx:=int(floor((p.y-s.y*0.29)/(h+8.0)))
   if idx>=0 and idx<opts.size():
    if idx==int(STAGES[stage]["pass"]):
     completed_choices.append(idx)
     stage+=1
     if stage>=STAGES.size():
      screen="ending"
      stage=7
     else:
      screen="stages"
     active_game=-1
     active_option=-1
     progress=0
     target=200
     round_no=1
     task_index=0
     mini_state.clear()
     _play_sfx("success")
     _save()
    else:
     active_option=idx
     active_game=int(STAGES[stage]["games"][idx])
     _start_minigame(active_game)
     screen="game"
     _play_sfx("move")
     _save()
 elif screen=="event":
  _handle_event_action(p,travel,s)
 elif screen=="game":
  if p.y>s.y-105 and p.x<190:
   screen="stages"
   _save()
   queue_redraw()
   return
  if p.x>s.x-100 and p.y<120:
   screen="settings"
  elif p.y>s.y*0.38 and p.y<s.y*0.72:
   _handle_minigame_action(p,travel,s)
  _save()
 elif screen=="ending":
  if p.y>s.y*0.74:
   screen="home"
   stage=0
   active_game=-1
   active_option=-1
   progress=0
   target=200
   total_actions=0
   round_no=1
   task_index=0
   mini_state.clear()
   completed_choices.clear()
   _play_sfx("success")
   _save(true)
 queue_redraw()

func _start_minigame(game_id:int)->void:
 selected_items.clear()
 tap_intervals.clear()
 last_game_tap_msec=0
 puzzle_rotation=rng.randi_range(0,7)
 mini_state={
  "turn":0,"step":0,"score":0,"budget":100,"spent":0,
  "safe_step":0,"network_node":0,"download_mask":0,
  "maze_pos":0,"maze_moves":0,"time_left":30,
  "memory_first":-1,"memory_found":[],"vehicle_x":0,
  "vehicle_y":0,"light":rng.randi_range(0,3),"light_target":posmod(task_index+round_no,4),
  "balance":0
 }
 if game_id==23:
  mini_state["time_left"]=30
 if game_id==5:
  _setup_pipe_board()
 audio_clock=0.0

func _setup_pipe_board()->void:
 var row:=posmod(task_index+round_no,3)
 var tiles:Array=[]
 for i in range(9):
  var r:=int(i/3)
  var col:=posmod(i,3)
  if r==row:
   tiles.append(1 if col!=1 else 0)
  else:
   tiles.append(posmod(i+puzzle_rotation,2))
 mini_state["pipe_row"]=row
 mini_state["pipe_tiles"]=tiles

func _pipes_connected(row:int)->bool:
 var tiles:Array=mini_state.get("pipe_tiles",[])
 if tiles.size()!=9:
  return false
 for col in range(3):
  if int(tiles[row*3+col])!=0:
   return false
 return true

func _cell_index(p:Vector2,area:Rect2,cols:int,rows:int)->int:
 if not area.has_point(p):
  return -1
 var cell_w:=area.size.x/float(cols)
 var cell_h:=area.size.y/float(rows)
 var col:=clampi(int((p.x-area.position.x)/cell_w),0,cols-1)
 var row:=clampi(int((p.y-area.position.y)/cell_h),0,rows-1)
 return row*cols+col

func _begin_event()->void:
 var kinds:=["captcha","loading","update","bank","support","signature","queue","otp","invoice","form"]
 event_kind=kinds[posmod(int(total_actions/17)-1,kinds.size())]
 event_code=rng.randi_range(1,9)*100+rng.randi_range(1,9)*10+rng.randi_range(1,9)
 event_entry=""
 event_step=0
 event_origin="game"
 screen="event"
 _notify("یک بررسی جانبی جدید")

func _draw_event(s:Vector2)->void:
 _header("رویداد جانبی","کاملاً ساختگی و بدون اتصال به اینترنت")
 var titles={
  "captcha":"تأیید تصویری نمایشی",
  "loading":"در حال پردازش درخواست",
  "update":"به‌روزرسانی ساختگی بازی",
  "bank":"تطبیق حساب آزمایشی",
  "support":"تماس با پشتیبانی نمایشی",
  "signature":"امضای دیجیتال تمرینی",
  "queue":"سامانه نوبت‌دهی",
  "otp":"کد یک‌بارمصرف آزمایشی",
  "invoice":"بررسی فاکتور",
  "form":"فرم چندمرحله‌ای"
 }
 _center(str(titles.get(event_kind,"بررسی جانبی")),s.y*0.25,21,C.gold)
 if event_kind=="captcha" or event_kind=="otp":
  _center("کد نمایشی: %03d" % event_code,s.y*0.34,25,C.white)
  _center("ورودی: "+"●".repeat(event_entry.length()),s.y*0.40,18,C.gold)
  var w:=s.x*0.22
  var h:=minf(48.0,s.y*0.065)
  for i in range(9):
   var col:=i%3
   var row:=int(i/3)
   _button(Rect2(s.x*0.5+(col-1)*(w+8)-w*0.5,s.y*0.45+row*(h+8),w,h),str(i+1),C.panel2)
  _button(Rect2(s.x*0.16,s.y*0.69,s.x*0.68,48),"تأیید کد",C.gold)
 elif event_kind=="bank":
  _center("کد تطبیق: کارت شمارهٔ %d" % (posmod(event_code,3)+1),s.y*0.37,14,C.muted)
  for i in range(3):
   _button(Rect2(s.x*0.12,s.y*0.43+i*58,s.x*0.76,48),"حساب آزمایشی ۰۰%d  •  کارت %d" % [i+1,i+5],C.panel2)
 elif event_kind=="queue":
  _center("شماره نوبت نمایشی: باجهٔ %d" % (posmod(event_code,3)+1),s.y*0.37,14,C.muted)
  for i in range(3):
   _button(Rect2(s.x*0.12,s.y*0.43+i*58,s.x*0.76,48),"باجهٔ شمارهٔ "+str(i+1),C.panel2)
 elif event_kind=="invoice":
  var invoice_items:=["قطعهٔ یدکی","هزینهٔ حمل","مالیات نمایشی","جمع کل"]
  var wanted:=posmod(event_code,4)
  _center("ردیف موردنیاز: "+invoice_items[wanted],s.y*0.37,14,C.muted)
  for i in range(4):
   _button(Rect2(s.x*0.12,s.y*0.40+i*55,s.x*0.76,46),invoice_items[i],C.panel2)
 elif event_kind=="signature":
  _center("برای ثبت امضای تمرینی، در کادر بکش",s.y*0.37,15,C.muted)
  draw_rect(Rect2(s.x*0.10,s.y*0.43,s.x*0.80,s.y*0.25),C.panel2,false,2)
  _center("محل امضا",s.y*0.57,18,C.muted)
 elif event_kind=="support":
  _center("پشتیبانی آزمایشی؛ تماس واقعی برقرار نمی‌شود",s.y*0.39,14,C.muted)
  _button(Rect2(s.x*0.14,s.y*0.50,s.x*0.72,58),"پایان تماس نمایشی",C.gold)
 elif event_kind=="loading" or event_kind=="update":
  var total:=3
  var ratio:=float(event_step)/float(total)
  draw_rect(Rect2(s.x*0.12,s.y*0.43,s.x*0.76,18),C.panel2)
  draw_rect(Rect2(s.x*0.12,s.y*0.43,s.x*0.76*ratio,18),C.green)
  _center("%d٪" % int(ratio*100.0),s.y*0.51,20,C.white)
  _button(Rect2(s.x*0.14,s.y*0.58,s.x*0.72,58),"ادامهٔ پردازش",C.gold)
 elif event_kind=="form":
  _center("فرم آزمایشی  •  بخش %d از ۳" % (event_step+1),s.y*0.42,17,C.white)
  _button(Rect2(s.x*0.14,s.y*0.55,s.x*0.72,58),"ثبت و رفتن به بخش بعد",C.gold)
 _button(Rect2(20,s.y-76,116,48),"بازگشت به بازی",C.panel)

func _handle_event_action(p:Vector2,travel:float,s:Vector2)->void:
 if p.y>s.y-100 and p.x<170:
  screen="game"
  _save(true)
  return
 if event_kind=="captcha" or event_kind=="otp":
  if p.y>=s.y*0.45 and p.y<s.y*0.69:
   var w:=s.x*0.22
   var h:=minf(48.0,s.y*0.065)
   for i in range(9):
    var col:=i%3
    var row:=int(i/3)
    var r:=Rect2(s.x*0.5+(col-1)*(w+8)-w*0.5,s.y*0.45+row*(h+8),w,h)
    if r.has_point(p) and event_entry.length()<3:
     event_entry+=str(i+1)
     _play_sfx("tap")
     return
  elif p.y>=s.y*0.69 and p.y<s.y*0.78:
   if event_entry==str(event_code):
    _complete_event()
   else:
    event_entry=""
    _game_miss("کد نمایشی درست وارد نشد؛ دوباره امتحان کن")
 elif event_kind=="bank" or event_kind=="queue":
  var y0:=s.y*0.43
  var index:=int(floor((p.y-y0)/58.0))
  if index>=0 and index<3:
   var correct:=posmod(event_code,3)
   if index==correct: _complete_event()
   else: _game_miss("این گزینه با درخواست آزمایشی هماهنگ نیست")
 elif event_kind=="invoice":
  var index:=int(floor((p.y-s.y*0.40)/55.0))
  if index>=0 and index<4:
   if index==posmod(event_code,4): _complete_event()
   else: _game_miss("ردیف فاکتور هنوز با سفارش مطابقت ندارد")
 elif event_kind=="signature":
  if travel>=28.0: _complete_event()
  else: _game_miss("امضا باید با حرکت انگشت کشیده شود")
 elif event_kind=="support":
  if p.y>=s.y*0.50 and p.y<s.y*0.72: _complete_event()
 elif event_kind=="loading" or event_kind=="update" or event_kind=="form":
  if p.y>=s.y*0.55 and p.y<s.y*0.73:
   event_step+=1
   if event_step>=3:
    _complete_event()
   else:
    _notify("بخش %d از ۳ انجام شد" % event_step)
    _play_sfx("tap")
 _save(true)
 queue_redraw()

func _complete_event()->void:
 screen="game"
 event_step=0
 event_entry=""
 _notify("بررسی جانبی با موفقیت ثبت شد")
 _play_sfx("success")
 _save(true)

func _game_success(message:String)->void:
 mini_state["step"]=int(mini_state.get("step",0))+1
 mini_state["turn"]=int(mini_state.get("turn",0))+1
 _advance_game()
 _notify(message)
 _play_sfx("success")

func _game_miss(message:String)->void:
 total_actions+=1
 if bool(settings.get("screen_shake",true)):
  shake_timer=0.18
 _notify(message)
 _play_sfx("error")
 if total_actions%25==0:
  target+=maxi(10,int(target*0.08))
  _notify("بررسی تازه‌ای به مأموریت اضافه شد")
 _save()

func _handle_minigame_action(p:Vector2,travel:float,s:Vector2)->void:
 var now:=Time.get_ticks_msec()
 if last_game_tap_msec>0:
  var interval:=float(now-last_game_tap_msec)
  tap_intervals.append(interval)
  if tap_intervals.size()>7:
   tap_intervals.pop_front()
  if tap_intervals.size()>=7:
   var average:=0.0
   for sample in tap_intervals:
    average+=sample
   average/=float(tap_intervals.size())
   var spread:=0.0
   for sample in tap_intervals:
    spread=maxf(spread,absf(sample-average))
   if average>=130.0 and average<=700.0 and spread<maxf(16.0,average*0.055):
    tap_intervals.clear()
    _begin_event()
    event_kind="captcha"
    _notify("برای ادامه، بررسی تصویری کوتاهی انجام بده")
    return
 last_game_tap_msec=now
 var center:=Vector2(s.x*0.5,s.y*0.53)
 var turn:=int(mini_state.get("turn",0))
 var step:=int(mini_state.get("step",0))
 var cell:=-1
 match active_game:
  0:
   var delta:=p-center
   if delta.length()>118.0 or delta.length()<18.0:
    _game_miss("برای چرخاندن، یکی از خانه‌های حلقه را لمس کن")
    return
   var sector:=posmod(int(round((atan2(delta.y,delta.x)+PI/2.0)/(TAU/6.0))),6)
   var expected:=posmod(task_index+round_no+step*2,6)
   if sector==expected: _game_success("یک دندانهٔ گاوصندوق تنظیم شد")
   else:
    mini_state["safe_step"]=0
    _game_miss("ترتیب قفل درست نبود؛ دوباره امتحان کن")
  1:
   cell=_cell_index(p,Rect2(center.x-135,center.y-65,265,142),2,2)
   if cell<0:
    _game_miss("یکی از دسته‌های هزینه را انتخاب کن")
   else:
    var cost:int=[34,26,18,12][cell]
    var spent_now:=int(mini_state.get("spent",0))
    var budget_now:=int(mini_state.get("budget",100))
    if spent_now+cost<=budget_now:
     mini_state["spent"]=spent_now+cost
     _game_success("هزینه ثبت شد؛ ماندهٔ بودجه: %d" % (budget_now-spent_now-cost))
    else:
     mini_state["spent"]=cost
     _game_success("دفتر هزینه بسته شد و بودجهٔ تازه‌ای باز شد")
  2:
   cell=_cell_index(p,Rect2(center.x-150,center.y+60,300,68),3,1)
   if cell<0:
    _game_miss("یکی از عددهای تراز را انتخاب کن")
   else:
    var expected:=posmod(task_index+round_no+turn,3)
    if cell==expected:
     _game_success("تراز دخل‌وخرج برابر شد")
    else:
     _game_miss("عدد انتخاب‌شده با تراز موردنیاز برابر نیست")
  3:
   cell=_cell_index(p,Rect2(center.x-135,center.y-55,270,135),3,1)
   var expected:=posmod(task_index+turn,3)
   if cell==expected: _game_success("منبع ضروری به‌درستی تخصیص یافت")
   else: _game_miss("اولویت بحران را دوباره بررسی کن")
  4:
   cell=_cell_index(p,Rect2(center.x-155,center.y-62,310,135),4,1)
   var expected:=posmod(task_index+turn,4)
   if cell==expected: _game_success("مدرک پرونده تأیید شد")
   else: _game_miss("این مدرک در این مرحله لازم نیست")
  5:
   cell=_cell_index(p,Rect2(center.x-125,center.y-115,250,220),3,3)
   if cell>=0:
    var tiles:Array=mini_state.get("pipe_tiles",[])
    if tiles.size()==9:
     tiles[cell]=1-posmod(int(tiles[cell]),2)
     mini_state["pipe_tiles"]=tiles
     var target_row:=int(mini_state.get("pipe_row",1))
     if _pipes_connected(target_row):
      _game_success("مسیر آب کامل و به خروجی وصل شد")
     else:
      _notify("اتصال هنوز کامل نیست؛ قطعه‌ها را بچرخان")
      _play_sfx("tap")
   else:
    _game_miss("یکی از قطعات شبکهٔ لوله را انتخاب کن")
  6:
   cell=_cell_index(p,Rect2(center.x-105,center.y-67,200,165),2,3)
   var expected:=posmod(task_index+turn+2,6)
   if cell==expected: _game_success("آسانسور به طبقهٔ درخواستی رسید")
   else: _game_miss("مسافر مقصد دیگری دارد")
  7:
   cell=_cell_index(p,Rect2(center.x-165,center.y-42,330,110),4,1)
   var expected:=posmod(task_index+round_no,4)
   if cell==expected: _game_success("قطعهٔ معیوب با قطعهٔ سالم عوض شد")
   else: _game_miss("این قطعه سالم است؛ مورد خراب را پیدا کن")
  8:
   cell=_cell_index(p,Rect2(center.x-150,center.y-52,300,115),3,1)
   var expected:=posmod(task_index+turn,3)
   if cell==expected: _game_success("سند با محموله تطبیق داشت")
   else: _game_miss("شمارهٔ سند با محموله هم‌خوانی ندارد")
  9:
   if travel<28.0:
    _game_miss("خودرو را با کشیدن انگشت هدایت کن")
    return
   var movement:=p-drag_start
   var direction:=0
   if absf(movement.x)>absf(movement.y): direction=0 if movement.x>0 else 1
   else: direction=2 if movement.y>0 else 3
   var expected:=posmod(task_index+turn,4)
   if direction==expected:
    mini_state["vehicle_x"]=int(mini_state.get("vehicle_x",0))+1
    _game_success("خودرو از مانع بعدی عبور کرد")
   else: _game_miss("مسیر اشتباه بود؛ فرمان را اصلاح کن")
  10:
   cell=_cell_index(p,Rect2(center.x-165,center.y-45,330,95),4,1)
   var expected:=posmod(turn+task_index,4)
   if cell==expected: _game_success("قطعه در ایستگاه بعدی نصب شد")
   else: _game_miss("ترتیب مونتاژ را رعایت کن")
  11:
   cell=_cell_index(p,Rect2(center.x-150,center.y-72,300,150),2,2)
   var expected_proposal:=posmod(task_index+turn,4)
   if cell==expected_proposal:
    mini_state["score"]=int(mini_state.get("score",0))+1
    _game_success("پیشنهاد درست در جلسه تصویب شد")
   else:
    _game_miss("این پیشنهاد با اولویت جلسه هماهنگ نیست")
  12:
   cell=_cell_index(p,Rect2(center.x-160,center.y-60,320,160),1,4)
   var expected:=posmod(task_index+round_no,4)
   if cell==expected: _game_success("باگ این بخش پیدا شد")
   else: _game_miss("این خط ایرادی ندارد؛ دوباره بررسی کن")
  13:
   cell=_cell_index(p,Rect2(center.x-150,center.y-58,300,150),4,2)
   if cell>=0:
    var shelf:=posmod(cell,4)
    if shelf==posmod(task_index+turn,4): _game_success("کالا در قفسهٔ درست قرار گرفت")
    else: _game_miss("جای این کالا در قفسهٔ دیگری است")
   else: _game_miss("یک کالا را برای قفسه‌بندی انتخاب کن")
  14:
   cell=_cell_index(p,Rect2(center.x-150,center.y-60,300,145),3,1)
   var expected:=posmod(task_index+turn,3)
   if cell==expected: _game_success("شیفت کاری ثبت شد")
   else: _game_miss("این جایگاه با برنامهٔ شیفت سازگار نیست")
  15:
   cell=_cell_index(p,Rect2(center.x-150,center.y-68,300,145),1,4)
   var expected_asset:=posmod(task_index+turn,4)
   if cell==expected_asset:
    mini_state["balance"]=int(mini_state.get("balance",0))+[10,20,15,5][cell]
    _game_success("دارایی در سبد مناسب قرار گرفت")
   else:
    _game_miss("ترکیب ریسک این سبد با سفارش سازگار نیست")
  16:
   cell=_cell_index(p,Rect2(center.x-150,center.y-20,300,150),4,1)
   if cell==1:
    _game_success("خالص پرداختی با کسر ۲۰٪ درست محاسبه شد")
   else:
    _game_miss("مالیات و بیمه را از حقوق ناخالص کم کن")
  17:
   cell=_cell_index(p,Rect2(center.x-160,center.y-60,320,140),4,1)
   var prices:Array=[15,25,35,45]
   if cell>=0:
    var spent:=int(mini_state.get("spent",0))
    var budget_now:=int(mini_state.get("budget",120))
    if spent+prices[cell]<=budget_now:
     mini_state["spent"]=spent+prices[cell]
     _game_success("کالا به سبد خرید اضافه شد؛ مانده: %d" % (budget_now-spent-prices[cell]))
    else:
     mini_state["spent"]=prices[cell]
     _game_success("سبد قبلی بسته شد؛ بودجهٔ خرید تازه فعال شد")
   else:
    _game_miss("یک کالا را انتخاب کن")
  18:
   var nodes:=[Vector2(-125,-10),Vector2(-42,-45),Vector2(48,-45),Vector2(126,0),Vector2(0,48)]
   var node:=-1
   for i in range(nodes.size()):
    if p.distance_to(center+nodes[i])<32.0: node=i
   if node==posmod(turn,5):
    mini_state["network_node"]=node
    _game_success("گره شبکه وصل شد؛ گره بعدی را پیدا کن")
   else: _game_miss("ترتیب اتصال گره‌ها صحیح نیست")
  19:
   if travel<28.0:
    _game_miss("برای تنظیم زاویه، انگشت را بکش")
    return
   var angle:=atan2(p.y-center.y,p.x-center.x)
   var expected_angle:=float(posmod(task_index+turn,8))*PI/4.0
   if absf(wrapf(angle-expected_angle,-PI,PI))<0.75: _game_success("قدرت سیگنال بهتر شد")
   else: _game_miss("زاویهٔ آنتن هنوز دقیق نیست")
  20:
   cell=_cell_index(p,Rect2(center.x-155,center.y-62,310,140),3,1)
   var expected:=posmod(task_index+turn+1,3)
   if cell==expected: _game_success("بستهٔ مناسب فعال شد")
   else: _game_miss("حجم بسته با مصرف موردنیاز تطبیق ندارد")
  21:
   cell=_cell_index(p,Rect2(center.x-165,center.y-45,330,115),5,1)
   var expected:=posmod(turn,5)
   if cell==expected:
    mini_state["download_mask"]=int(mini_state.get("download_mask",0)) | (1<<cell)
    _game_success("تکهٔ فایل بازیابی شد")
   else: _game_miss("ترتیب تکه‌های فایل را رعایت کن")
  22:
   cell=_cell_index(p,Rect2(center.x-165,center.y+25,330,65),4,1)
   var seed:=posmod(task_index+round_no+turn,4)
   var expected:=posmod(seed+1,4)
   if cell==expected:
    _game_success("الگوی منطقی کامل شد")
   else:
    _game_miss("ادامهٔ الگو با قاعدهٔ شکل‌ها هماهنگ نیست")
  23:
   cell=_cell_index(p,Rect2(center.x-160,center.y+5,320,75),4,1)
   var left_value:=task_index+turn+4
   var right_value:=round_no+posmod(turn,3)+2
   var answer_value:=(left_value+right_value)*2
   if cell==2:
    mini_state["time_left"]=30
    _game_success("محاسبه درست بود؛ سؤال بعدی آماده شد")
   else:
    _game_miss("پاسخ محاسبه اشتباه است")
  24:
   cell=_cell_index(p,Rect2(center.x-135,center.y-62,270,140),3,2)
   if cell<0: _game_miss("یکی از کارت‌ها را لمس کن")
   elif int(mini_state.get("memory_first",-1))<0:
    mini_state["memory_first"]=cell
    _notify("کارت اول ثبت شد؛ کارت همسان را پیدا کن")
    _play_sfx("tap")
   else:
    var first:=int(mini_state.get("memory_first",-1))
    mini_state["memory_first"]=-1
    if first!=cell and int(first/2)==int(cell/2):
     var found:Array=mini_state.get("memory_found",[])
     found.append(first)
     found.append(cell)
     mini_state["memory_found"]=found
     _game_success("جفت کارت‌ها پیدا شد")
    else: _game_miss("این دو کارت همسان نیستند")
  25:
   if travel<28.0:
    _game_miss("در هزارتو با کشیدن انگشت حرکت کن")
    return
   var movement:=p-drag_start
   var direction:=0
   if absf(movement.x)>absf(movement.y):
    direction=0 if movement.x>0 else 1
   else:
    direction=2 if movement.y>0 else 3
   var offsets:Array=[1,-1,5,-5]
   var position:=int(mini_state.get("maze_pos",0))
   var next_position:=position+int(offsets[direction])
   var maze_path:Array=[0,5,6,11,12,17,18,19]
   var path_index:=maze_path.find(position)
   var expected_next:int=-1
   if path_index>=0 and path_index<maze_path.size()-1:
    expected_next=int(maze_path[path_index+1])
   if direction==0 and int(position/5)!=int(next_position/5):
    expected_next=-1
   if direction==1 and int(position/5)!=int(next_position/5):
    expected_next=-1
   if next_position==expected_next:
    mini_state["maze_pos"]=next_position
    mini_state["maze_moves"]=int(mini_state.get("maze_moves",0))+1
    if next_position==19:
     mini_state["maze_pos"]=0
     _game_success("از هزارتو خارج شدی؛ مسیر تازه ساخته شد")
    else:
     _notify("مسیر درست است؛ ادامه بده")
     _play_sfx("move")
   else:
    _game_miss("این راه به بن‌بست می‌رسد؛ مسیر را دوباره پیدا کن")
  26:
   cell=_cell_index(p,Rect2(center.x-155,center.y-62,310,150),3,1)
   var expected_style:=posmod(task_index+round_no+turn,3)
   if cell==expected_style:
    mini_state["score"]=int(mini_state.get("score",0))+1
    _game_success("استایل مطابق درخواست مشتری انتخاب شد")
   else:
    _game_miss("مدل انتخاب‌شده با درخواست مشتری مطابقت ندارد")
  27:
   if travel<28.0:
    _game_miss("برای تنظیم تقارن، انگشت را افقی بکش")
    return
   var expected_direction:=1 if posmod(task_index+turn,2)==0 else -1
   if signf((p-drag_start).x)==float(expected_direction):
    puzzle_rotation=posmod(puzzle_rotation+1,8)
    _game_success("جزئیات چهره متقارن‌تر شد")
   else: _game_miss("حرکت را در جهت درست انجام بده")
  28:
   var adjustment:=0
   if p.x<center.x-45:
    adjustment=-1
   elif p.x>center.x+45:
    adjustment=1
   if adjustment==0:
    _notify("برای تغییر نور، سمت چپ یا راست کادر را لمس کن")
   else:
    mini_state["light"]=clampi(int(mini_state.get("light",1))+adjustment,0,3)
    var current_light:=int(mini_state.get("light",1))
    var target_light:=int(mini_state.get("light_target",1))
    if current_light==target_light:
     _game_success("نورپردازی با نمونه یکسان شد")
    else:
     _notify("نور فعلی %d است؛ نمونه %d می‌خواهد" % [current_light,target_light])
     _play_sfx("tap")
  29:
   cell=_cell_index(p,Rect2(center.x-160,center.y-60,320,140),4,1)
   var expected:=posmod(task_index+turn,4)
   if cell==expected: _game_success("یک بخش از پوشش نهایی انتخاب شد")
   else: _game_miss("این بخش با ترکیب درخواستی هماهنگ نیست")
  _:
   _game_miss("حرکت در مأموریت ثبت نشد")

func _advance_game()->void:
 total_actions+=1
 progress+=1
 if progress>=target:
  progress=0
  round_no+=1
  task_index+=1
  var difficulty_growth:float=[0.6,1.0,1.6][clampi(int(settings.get("difficulty",1)),0,2)]
  target+=maxi(50,int(float(target)*difficulty_growth))
  puzzle_rotation=rng.randi_range(0,7)
  if active_game==1 or active_game==17:
   mini_state["spent"]=0
  if active_game==5:
   _setup_pipe_board()
  elif active_game==25:
   mini_state["maze_pos"]=0
  elif active_game==28:
   mini_state["light"]=rng.randi_range(0,3)
   mini_state["light_target"]=posmod(task_index+round_no,4)
  _notify("مأموریت تازه: "+GAME_HINTS[active_game])
 elif total_actions%25==0:
  target+=int(target*0.15)
  _notify("یک بخش تازه اضافه شد؛ ادامه بده")
 else:
  _notify(["خوب پیش می‌روی","یک قطعه دیگر پیدا شد","درخواست تازه رسید","مرحله بررسی تمدید شد"][rng.randi_range(0,3)])
 if total_actions>0 and total_actions%17==0:
  _begin_event()

func _fmt(n:int)->String:
 return str(n)

func _notify(t:String)->void:
 toast=t
 toast_timer=2.2

func _save(force:bool=false)->void:
 if not force and not bool(settings.get("auto_save",true)):
  return
 config.set_value("progress","stage",stage)
 config.set_value("progress","active_game",active_game)
 config.set_value("progress","active_option",active_option)
 config.set_value("progress","progress",progress)
 config.set_value("progress","target",target)
 config.set_value("progress","total_actions",total_actions)
 config.set_value("progress","round_no",round_no)
 config.set_value("progress","task_index",task_index)
 config.set_value("progress","puzzle_rotation",puzzle_rotation)
 config.set_value("progress","completed_choices",completed_choices)
 config.set_value("progress","mini_state",mini_state)
 config.set_value("settings","all",settings)
 config.save(SAVE_PATH)

func _load_save()->void:
 config=ConfigFile.new()
 stage=0
 active_game=-1
 active_option=-1
 progress=0
 target=200
 total_actions=0
 round_no=1
 task_index=0
 puzzle_rotation=0
 completed_choices.clear()
 mini_state.clear()
 settings={
  "music":true,"effects":true,"volume":80,
  "music_volume":45,"effects_volume":75,
  "animation_speed":1,"difficulty":1,
  "visual_effects":true,"theme":0,"auto_save":true,
  "screen_shake":true,"particles":true,"haptics":true
 }
 if config.load(SAVE_PATH)!=OK:
  _apply_audio_settings()
  return
 stage=clampi(int(config.get_value("progress","stage",0)),0,7)
 active_game=int(config.get_value("progress","active_game",-1))
 active_option=int(config.get_value("progress","active_option",-1))
 progress=maxi(0,int(config.get_value("progress","progress",0)))
 target=maxi(200,int(config.get_value("progress","target",200)))
 total_actions=maxi(0,int(config.get_value("progress","total_actions",0)))
 round_no=maxi(1,int(config.get_value("progress","round_no",1)))
 task_index=maxi(0,int(config.get_value("progress","task_index",0)))
 puzzle_rotation=int(config.get_value("progress","puzzle_rotation",0))
 var choices:Variant=config.get_value("progress","completed_choices",[])
 if choices is Array:
  completed_choices=choices
 var saved_state:Variant=config.get_value("progress","mini_state",{})
 if saved_state is Dictionary:
  mini_state=saved_state
 var saved:Variant=config.get_value("settings","all",{})
 if saved is Dictionary:
  for key in settings.keys():
   if saved.has(key):
    settings[key]=saved[key]
 _apply_audio_settings()
