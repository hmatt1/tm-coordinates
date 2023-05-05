enum displays {
    Only_when_Openplanet_menu_is_open,
    Always_except_when_interface_is_hidden,
    Always
}

[Setting name="Enabled" category="UI"]
bool setting_enabled = true;

[Setting name="Display setting" category="UI"]
displays setting_display = displays::Always_except_when_interface_is_hidden;

[Setting name="Display x coordinate" category="UI"]
bool setting_x = true;

[Setting name="Display y coordinate" category="UI"]
bool setting_y = true;

[Setting name="Display z coordinate" category="UI"]
bool setting_z = true;

enum RenderMode {
    Normal,
    Interface
}

void Render() {
  if (can_render(RenderMode::Normal)) render_stats();
}

void RenderInterface() {
  if (can_render(RenderMode::Interface)) render_stats();
}

void render_stats() {

    int window_flags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::NoDocking;
    UI::Begin("Coordinates", window_flags);
    UI::BeginGroup();

    auto scene = GetApp().GameScene;
    if (scene is null) {
        UI::Text("Missing scene");
    } else {
      CSceneVehicleVis@ vis = VehicleState::GetSingularVis(scene);
      if (vis is null) {
       auto p = VehicleState::GetViewingPlayer();
       if (p !is null)
           @vis = VehicleState::GetVis(scene, p);
      }
      if (vis is null) {
        UI::Text("No vehicle");
      } else {
        if (setting_x) {
          UI::Text("x: " + vis.AsyncState.Position.x);
        }
        if (setting_y) {
          UI::Text("y: " + vis.AsyncState.Position.y);
        }
        if (setting_z) {
          UI::Text("z: " + vis.AsyncState.Position.z);
        }
      }
    }
    UI::EndGroup();
    UI::End();
}

bool can_render(RenderMode rendermode) {
    if (rendermode == RenderMode::Normal && (!setting_enabled || setting_display == displays::Only_when_Openplanet_menu_is_open)) return false;
    if (rendermode == RenderMode::Interface && (!setting_enabled || setting_display != displays::Only_when_Openplanet_menu_is_open)) return false;

    auto app = cast<CTrackMania>(GetApp());
    auto map = app.RootMap;
    if (map is null || map.MapInfo.MapUid == "" || app.Editor !is null) return false;
    if (app.CurrentPlayground is null || app.CurrentPlayground.Interface is null  ||
     (setting_display == displays::Always_except_when_interface_is_hidden && !UI::IsGameUIVisible())) return false;
    return true;
}
