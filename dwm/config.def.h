//TODO: Colours
//TODO: Fonts
//TODO: window bar title names
//TODO: openVPN widget
//TODO: widgets

#include <X11/XF86keysym.h>

/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = {
  "mononoki:size=12",
  "Font Awesome 5 Free:12",
  "Font Awesome 5 Free Solid:12",
  "Font Awesome 5 Brands,Font Awesome 5 Brands Regular:12"
};
static const char dmenufont[]       = "mononoki:size=16";
static const char col_light_gray[]       = "#dddddd"; //BG normal
static const char tag_unsel_bg[]       = "#111114"; //BG normal
static const char border_unsel[]       = "#444444";
static const char tag_unsel_fg[]       = "#719299"; //unselected FG
static const char tag_sel_fg[]       = "#fea47f"; //selected FG
static const char tag_sel_bg[]        = "#005577"; //selected BG
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { tag_unsel_fg, tag_unsel_bg, border_unsel },
	[SchemeSel]  = { tag_sel_fg, tag_sel_bg,  tag_sel_fg  },
	[SchemeOtherMon]  = { tag_unsel_fg, border_unsel,  tag_sel_bg  },
	[SchemeSelWindow] = { col_light_gray, tag_sel_bg,  tag_sel_fg  }
};
static const int barpadding_vertical = 6;


static Layout layouts[] = {
	/* symbol     arrange function */
	{ "[  ]",   tile },    /* first entry is default */
	{ "[  ]",   monocle },
	{ "[  ]",   col },
	{ "[  ]",   NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* tagging */
static Tag tags[2][9] = {
  {
    {.name = "",   .lt = &layouts[0], .mfact = 0.75, .nmaster = 1, .shared = 0},
    {.name = "",   .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 0},
    {.name = "",    .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",   .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",   .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1}
  },
  {
    {.name = " ", .lt = &layouts[0], .mfact = 0.75, .nmaster = 1, .shared = 0},
    {.name = "",    .lt = &layouts[2], .mfact = 0.5, .nmaster = 4, .shared = 0},
    {.name = "",    .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",    .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",   .lt = &layouts[0], .mfact = 0.5, .nmaster = 1, .shared = 1},
    {.name = "",   .lt = &layouts[1], .mfact = 0.5, .nmaster = 1, .shared = 1}
  },
};

static const char *tagsalt[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
//	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.75; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", tag_unsel_bg, "-nf", tag_unsel_fg, "-sb", tag_sel_bg, "-sf", tag_sel_fg, NULL };
static const char *termcmd[]  = { "terminator", NULL };
static const char *browsercmd[] = { "brave-browser", NULL };
//static const char *browsercmd[] = { "brave", NULL };
static const char *webstormcmd[] = { "webstorm", NULL };
static const char *nautiluscmd[] = { "nautilus", "-w", NULL };
//static const char *lockcmd[] = { "light-locker-command", "-l", NULL };
static const char *lockcmd[] = { "i3lock", "-c", "002028", NULL };
static const char *spply[] = { "sp", "play", NULL };
static const char *spnxt[] = { "sp", "next", NULL };
static const char *splst[] = { "sp", "prev", NULL };
static const char *downvol[] = { "amixer", "-D", "pulse", "sset", "Master", "5%-", NULL };
static const char *upvol[] = { "amixer", "-D", "pulse", "sset", "Master", "5%+", NULL };
static const char *mutevol[] = { "amixer", "set", "Master", "toggle",     NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_Return, spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      spawn,          {.v = browsercmd } },
	{ MODKEY,                       XK_l,      spawn,          {.v = lockcmd } },
	{ MODKEY,                       XK_w,      spawn,          {.v = webstormcmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = nautiluscmd } },
	{ 0,                            XF86XK_AudioLowerVolume, spawn, {.v = downvol } },
	{ 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = upvol } },
	{ 0,                            XF86XK_AudioMute, spawn,   {.v = mutevol } },
	{ MODKEY,                       XK_v,      vpnconnect,     {0} },
	{ MODKEY|ShiftMask|ControlMask, XK_space,  togglebar,      {0} },
	{ MODKEY,                       XK_Left,   focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_Right,  focusstack,     {.i = +1 } },
  { MODKEY|ShiftMask,             XK_Right,  movestack,      {.i = +1 } },
  { MODKEY|ShiftMask,             XK_Left,   movestack,      {.i = -1 } },
	{ MODKEY,                       XK_Up,     incntag,        {.i = -1 } },
	{ MODKEY,                       XK_Down,   incntag,        {.i = +1 }   },
	{ MODKEY|ShiftMask,             XK_equal,  incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_minus,  incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_minus,  setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_equal,  setmfact,       {.f = +0.05} },
	//{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	//{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	//{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	//{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,           	        	XK_space,  cyclelayout,    {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_space,  cyclelayout,    {.i = +1 } },
	//{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_f,      togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ ControlMask|Mod1Mask,         XK_Right,  tagmon,         {.i = +1 } },
  { ControlMask|Mod1Mask,         XK_Left,   tagmon,         {.i = -1 } },
	{ MODKEY|ControlMask,           XK_Right,  focusmon,       {.i = +1 } },
	{ MODKEY|ControlMask,           XK_Left,   focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_n,      togglealttag,   {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        spawn,          {.v = spply } },
	{ ClkStatusText,        0,              Button4,        spawn,          {.v = spnxt } },
	{ ClkStatusText,        0,              Button5,        spawn,          {.v = splst } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

