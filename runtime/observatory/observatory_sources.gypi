# Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# This file contains all dart, css, and html sources for Observatory.
{
  'sources': [
    'lib/app.dart',
    'lib/cli.dart',
    'lib/cpu_profile.dart',
    'lib/debugger.dart',
    'lib/elements.dart',
    'lib/elements.html',
    'lib/models.dart',
    'lib/object_graph.dart',
    'lib/repositories.dart',
    'lib/service.dart',
    'lib/service_common.dart',
    'lib/service_html.dart',
    'lib/service_io.dart',
    'lib/src/app/analytics.dart',
    'lib/src/app/application.dart',
    'lib/src/app/event.dart',
    'lib/src/app/location_manager.dart',
    'lib/src/app/notification.dart',
    'lib/src/app/page.dart',
    'lib/src/app/settings.dart',
    'lib/src/app/view_model.dart',
    'lib/src/cli/command.dart',
    'lib/src/cpu_profile/cpu_profile.dart',
    'lib/src/debugger/debugger.dart',
    'lib/src/debugger/debugger_location.dart',
    'lib/src/elements/action_link.dart',
    'lib/src/elements/action_link.html',
    'lib/src/elements/class_ref.dart',
    'lib/src/elements/class_ref_wrapper.dart',
    'lib/src/elements/class_ref_as_value.dart',
    'lib/src/elements/class_ref_as_value.html',
    'lib/src/elements/class_tree.dart',
    'lib/src/elements/class_view.dart',
    'lib/src/elements/class_view.html',
    'lib/src/elements/code_ref.dart',
    'lib/src/elements/code_ref_wrapper.dart',
    'lib/src/elements/code_view.dart',
    'lib/src/elements/code_view.html',
    'lib/src/elements/context_ref.dart',
    'lib/src/elements/context_ref.html',
    'lib/src/elements/context_view.dart',
    'lib/src/elements/context_view.html',
    'lib/src/elements/containers/virtual_collection.dart',
    'lib/src/elements/containers/virtual_tree.dart',
    'lib/src/elements/cpu_profile.dart',
    'lib/src/elements/cpu_profile.html',
    'lib/src/elements/css/shared.css',
    'lib/src/elements/curly_block.dart',
    'lib/src/elements/curly_block_wrapper.dart',
    'lib/src/elements/debugger.dart',
    'lib/src/elements/debugger.html',
    'lib/src/elements/error_ref.dart',
    'lib/src/elements/error_ref_wrapper.dart',
    'lib/src/elements/error_view.dart',
    'lib/src/elements/error_view.html',
    'lib/src/elements/eval_box.dart',
    'lib/src/elements/eval_box.html',
    'lib/src/elements/eval_link.dart',
    'lib/src/elements/eval_link.html',
    'lib/src/elements/field_ref.dart',
    'lib/src/elements/field_ref.html',
    'lib/src/elements/field_view.dart',
    'lib/src/elements/field_view.html',
    'lib/src/elements/flag_list.dart',
    'lib/src/elements/function_ref.dart',
    'lib/src/elements/function_ref_wrapper.dart',
    'lib/src/elements/function_view.dart',
    'lib/src/elements/function_view.html',
    'lib/src/elements/general_error.dart',
    'lib/src/elements/heap_map.dart',
    'lib/src/elements/heap_map.html',
    'lib/src/elements/heap_profile.dart',
    'lib/src/elements/heap_profile.html',
    'lib/src/elements/heap_snapshot.dart',
    'lib/src/elements/heap_snapshot.html',
    'lib/src/elements/helpers/rendering_queue.dart',
    'lib/src/elements/helpers/rendering_scheduler.dart',
    'lib/src/elements/helpers/tag.dart',
    'lib/src/elements/helpers/uris.dart',
    'lib/src/elements/icdata_view.dart',
    'lib/src/elements/icdata_view.html',
    'lib/src/elements/img/chromium_icon.png',
    'lib/src/elements/img/dart_icon.png',
    'lib/src/elements/img/isolate_icon.png',
    'lib/src/elements/inbound_reference.dart',
    'lib/src/elements/inbound_reference.html',
    'lib/src/elements/instance_ref.dart',
    'lib/src/elements/instance_ref.html',
    'lib/src/elements/instance_view.dart',
    'lib/src/elements/instance_view.html',
    'lib/src/elements/instructions_view.dart',
    'lib/src/elements/instructions_view.html',
    'lib/src/elements/io_view.dart',
    'lib/src/elements/io_view.html',
    'lib/src/elements/isolate_reconnect.dart',
    'lib/src/elements/isolate_ref.dart',
    'lib/src/elements/isolate_ref_wrapper.dart',
    'lib/src/elements/isolate_summary.dart',
    'lib/src/elements/isolate_summary.html',
    'lib/src/elements/isolate_view.dart',
    'lib/src/elements/isolate_view.html',
    'lib/src/elements/json_view.dart',
    'lib/src/elements/json_view.html',
    'lib/src/elements/library_ref.dart',
    'lib/src/elements/library_ref_wrapper.dart',
    'lib/src/elements/library_ref_as_value.dart',
    'lib/src/elements/library_ref_as_value.html',
    'lib/src/elements/library_view.dart',
    'lib/src/elements/library_view.html',
    'lib/src/elements/objectstore_view.dart',
    'lib/src/elements/objectstore_view.html',
    'lib/src/elements/logging.dart',
    'lib/src/elements/logging.html',
    'lib/src/elements/megamorphiccache_view.dart',
    'lib/src/elements/megamorphiccache_view.html',
    'lib/src/elements/metrics.dart',
    'lib/src/elements/metrics.html',
    'lib/src/elements/nav/bar.dart',
    'lib/src/elements/nav/class_menu.dart',
    'lib/src/elements/nav/class_menu_wrapper.dart',
    'lib/src/elements/nav/isolate_menu.dart',
    'lib/src/elements/nav/isolate_menu_wrapper.dart',
    'lib/src/elements/nav/library_menu.dart',
    'lib/src/elements/nav/library_menu_wrapper.dart',
    'lib/src/elements/nav/menu_item.dart',
    'lib/src/elements/nav/menu_item_wrapper.dart',
    'lib/src/elements/nav/menu.dart',
    'lib/src/elements/nav/menu_wrapper.dart',
    'lib/src/elements/nav/notify_event.dart',
    'lib/src/elements/nav/notify_exception.dart',
    'lib/src/elements/nav/notify.dart',
    'lib/src/elements/nav/notify_wrapper.dart',
    'lib/src/elements/nav/refresh.dart',
    'lib/src/elements/nav/refresh_wrapper.dart',
    'lib/src/elements/nav/top_menu.dart',
    'lib/src/elements/nav/top_menu_wrapper.dart',
    'lib/src/elements/nav/vm_menu.dart',
    'lib/src/elements/nav/vm_menu_wrapper.dart',
    'lib/src/elements/object_common.dart',
    'lib/src/elements/object_common.html',
    'lib/src/elements/object_view.dart',
    'lib/src/elements/object_view.html',
    'lib/src/elements/objectpool_view.dart',
    'lib/src/elements/objectpool_view.html',
    'lib/src/elements/observatory_application.dart',
    'lib/src/elements/observatory_application.html',
    'lib/src/elements/observatory_element.dart',
    'lib/src/elements/persistent_handles.dart',
    'lib/src/elements/persistent_handles.html',
    'lib/src/elements/ports.dart',
    'lib/src/elements/ports.html',
    'lib/src/elements/script_inset.dart',
    'lib/src/elements/script_inset.html',
    'lib/src/elements/script_ref_wrapper.dart',
    'lib/src/elements/script_ref.dart',
    'lib/src/elements/script_view.dart',
    'lib/src/elements/script_view.html',
    'lib/src/elements/service_ref.dart',
    'lib/src/elements/service_ref.html',
    'lib/src/elements/service_view.dart',
    'lib/src/elements/service_view.html',
    'lib/src/elements/source_link_wrapper.dart',
    'lib/src/elements/source_link.dart',
    'lib/src/elements/shims/binding.dart',
    'lib/src/elements/timeline_page.dart',
    'lib/src/elements/timeline_page.html',
    'lib/src/elements/view_footer.dart',
    'lib/src/elements/vm_connect_target.dart',
    'lib/src/elements/vm_connect.dart',
    'lib/src/elements/vm_view.dart',
    'lib/src/elements/vm_view.html',
    'lib/src/models/exceptions.dart',
    'lib/src/models/objects/breakpoint.dart',
    'lib/src/models/objects/class.dart',
    'lib/src/models/objects/code.dart',
    'lib/src/models/objects/error.dart',
    'lib/src/models/objects/event.dart',
    'lib/src/models/objects/extension_data.dart',
    'lib/src/models/objects/flag.dart',
    'lib/src/models/objects/frame.dart',
    'lib/src/models/objects/function.dart',
    'lib/src/models/objects/instance.dart',
    'lib/src/models/objects/isolate.dart',
    'lib/src/models/objects/library.dart',
    'lib/src/models/objects/notification.dart',
    'lib/src/models/objects/object.dart',
    'lib/src/models/objects/script.dart',
    'lib/src/models/objects/source_location.dart',
    'lib/src/models/objects/target.dart',
    'lib/src/models/objects/timeline_event.dart',
    'lib/src/models/objects/vm.dart',
    'lib/src/models/repositories/class.dart',
    'lib/src/models/repositories/event.dart',
    'lib/src/models/repositories/flag.dart',
    'lib/src/models/repositories/instance.dart',
    'lib/src/models/repositories/notification.dart',
    'lib/src/models/repositories/script.dart',
    'lib/src/models/repositories/target.dart',
    'lib/src/repositories/class.dart',
    'lib/src/repositories/event.dart',
    'lib/src/repositories/flag.dart',
    'lib/src/repositories/instance.dart',
    'lib/src/repositories/notification.dart',
    'lib/src/repositories/script.dart',
    'lib/src/repositories/settings.dart',
    'lib/src/repositories/target.dart',
    'lib/src/service/object.dart',
    'lib/tracer.dart',
    'lib/utils.dart',
    'web/favicon.ico',
    'web/index.html',
    'web/main.dart',
    'web/third_party/trace_viewer_full.html',
    'web/timeline.html',
    'web/timeline.js',
    'web/timeline_message_handler.js',
  ],
}
