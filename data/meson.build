if host_machine.system() != 'windows'
  desktop = 'org.virt-manager.virt-viewer.desktop'

  i18n.merge_file (
    type: 'desktop',
    input: desktop + '.in',
    output: desktop,
    po_dir: po_dir,
    install: true,
    install_dir: join_paths(datadir, 'applications')
  )

  mimetypes = 'virt-viewer-mime.xml'

  i18n.merge_file (
    type: 'xml',
    input: mimetypes + '.in',
    output: mimetypes,
    data_dirs: i18n_itsdir,
    po_dir: po_dir,
    install: true,
    install_dir: join_paths(datadir, 'mime', 'packages')
  )

  metainfo = 'org.virt-manager.virt-viewer.appdata.xml'

  i18n.merge_file (
    type: 'xml',
    input: metainfo + '.in',
    output: metainfo,
    po_dir: po_dir,
    install: true,
    install_dir: join_paths(datadir, 'metainfo')
  )
endif

with_msi=false
if host_machine.system() == 'windows'
  wixl = find_program('wixl', required: false)
  wixl_heat = find_program('wixl-heat', required: false)

  if wixl.found() and wixl_heat.found()
    with_msi=true
  endif
endif

if with_msi
  buildenv = custom_target(
    'buildenv.txt',
    output: ['buildenv.txt'],
    command: [
      python3,
      buildenv_prog.full_path(),
    ],
    capture: true)

  msi_filename = 'virt-viewer-@0@-@1@.msi'.format(wixl_arch, meson.project_version())

  if libvirt_dep.found()
    wixl_libvirt_arg = 'True'
  else
    wixl_libvirt_arg = 'False'
  endif

  if spice_gtk_dep.found()
    wixl_spice_gtk_arg = 'True'
  else
    wixl_spice_gtk_arg = 'False'
  endif

  if gtk_vnc_dep.found()
    wixl_gtk_vnc_arg = 'True'
  else
    wixl_gtk_vnc_arg = 'False'
  endif

  if govirt_dep.found()
    wixl_govirt_arg = 'True'
  else
    wixl_govirt_arg = 'False'
  endif

  wxsfile = configure_file(
    input: 'virt-viewer.wxs.in',
    output: 'virt-viewer.wxs',
    configuration: conf_data
  )

  msi = custom_target(
    msi_filename,
    input: [wxsfile, buildenv],
    output: [msi_filename],
    build_by_default: false,
    command: [
      python3,
      msitool_prog.full_path(),
      meson.build_root(),
      prefix,
      wixl_arch,
      join_paths(meson.build_root(), 'data', msi_filename),
      wxsfile,
      buildenv,
      wixl_heat,
      wixl,
      wixl_spice_gtk_arg,
      wixl_gtk_vnc_arg,
      wixl_libvirt_arg,
      wixl_govirt_arg,
    ],
  )

endif
