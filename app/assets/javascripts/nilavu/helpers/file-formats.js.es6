export function formatFileSize(bytes) {
  if (typeof bytes !== 'number') {
      return '';
  }

  if (bytes >= 1000000000) {
      return (bytes / 1000000000).toFixed(2) + ' GB';
  }

  if (bytes >= 1000000) {
      return (bytes / 1000000).toFixed(2) + ' MB';
  }

  return (bytes / 1000).toFixed(2) + ' KB';
}

export function formatFileIcons(name) {
  if (name == '7z' || name == 'cbz' || name == 'cpio' || name == 'exe' || name == 'war' || name == 'iso' || name == 'ar' || name == 'tar.gz' || name == 'tar.Z' || name == 'tar.bz2' || name == 'tar.7z' || name == 'tar.lz' || name == 'tar.xz' || name == 'tar' || name == 'zip' || name == 'tgz' || name == 'rar' || name == 'jar' || name == 'gzip' || name == 'gz' || name == 'bz2') {
      return 'c_icon-zip'
  } else if (name == 'csv' || name == 'doc' || name == 'docx' || name == 'eml' || name == 'eps' || name == 'html' || name == 'html4' || name == 'html5' || name == 'key' || name == 'odp' || name == 'ods' || name == 'odt' || name == 'pdf' || name == 'ppt' || name == 'pst' || name == 'txt' || name == 'xml' || name == 'xps') {
      return 'c_icon-text'
  } else if (name == 'arw' || name == 'bmp' || name == 'cdr' || name == 'cr2' || name == 'crw' || name == 'dng' || name == 'erf' || name == 'gif' || name == 'ico' || name == 'jpg' || name == 'mdi' || name == 'mef' || name == 'mrw' || name == 'nef' || name == 'odg' || name == 'orf' || name == 'pcx' || name == 'pef' || name == 'ppm' || name == 'psd' || name == 'raf' || name == 'raw' || name == 'sr2' || name == 'tga' || name == 'thumbnail' || name == 'tiff' || name == 'wbmp' || name == 'webp' || name == 'wmf' || name == 'x3f' || name == 'xcf') {
      return 'c_icon-jpg'
  } else if (name == 'png') {
      return 'c_icon-png'
  } else if (name == 'svg') {
      return 'c_icon-svg'
  } else {
      return 'c_icon-text'
  }
}
