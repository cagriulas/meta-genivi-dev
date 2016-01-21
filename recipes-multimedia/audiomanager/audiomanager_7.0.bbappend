FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

DEPENDS_append = " pulseaudio"

SRC_URI_append = " git://git.projects.genivi.org/AudioManagerPlugins.git;destsuffix=git/Plugins;branch=${BRANCH};tag=${PV} \
                   file://0001-Porting-Pulse-Routing-Interface-from-AM-v1.x-to-AM-v.patch \
                   file://0001-Porting-Pulse-Control-Interface-from-AM-v1.x-to-AM-v.patch \
                   file://sqlite_database_handler_change_mainVolume_to_volume.patch \
                   file://AudioManager_user.service \
                   file://0001-Updated-PluginControlInterfacePulse-control-sender-t.patch \
                 "
EXTRA_OECMAKE += "-DWITH_PULSE_ROUTING_PLUGIN=ON -DWITH_PULSE_CONTROL_PLUGIN=ON -DWITH_ENABLED_IPC=DBUS -DWITH_DATABASE_STORAGE=OFF"

do_install_append() {
    mkdir -p ${D}/etc/systemd/user
    cp ${WORKDIR}/AudioManager_user.service ${D}/etc/systemd/user/AudioManager.service
    mkdir -p ${D}/etc/systemd/user/default.target.wants
    ln -sf /etc/systemd/user/AudioManager.service ${D}/etc/systemd/user/default.target.wants/AudioManager.service
}

FILES_${PN} += "${libdir}/audioManager/control/* \
                ${libdir}/audioManager/routing/* \
               "