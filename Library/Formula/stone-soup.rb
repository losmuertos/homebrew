require 'formula'

# we need access to the locally cloned repository in order to get the current
# version string using git describe.
class HeadDownloadStrategy <GitDownloadStrategy
  def stage
    # current directory is the temporary build directory
    stagedir= Dir.getwd
    # switch to the directory containing the cloned repository
    Dir.chdir cached_location
    # since we have not yet exported the repository to the local build dir,
    # create the dir where we need the version file to go in the local
    # build directory.
    versiondir = Pathname.new("#{stagedir}/crawl-ref/source/util")
    versiondir.mkpath
    # we create a file containing the latest version so the build won't fail.
    `git describe --tags --long > #{versiondir}/release_ver`
    # switch back to the temporary directory and perform the rest of the 
    # staging task as usual
    Dir.chdir stagedir
    super
  end
end

class StoneSoup <Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.7.1/stone_soup-0.7.1.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 'e95e538264bbcf6db64cec920d669542'
  head 'git://gitorious.org/crawl/crawl.git', :branch => 'master', :using => HeadDownloadStrategy

  def install
    if ARGV.build_head?
      Dir.chdir "crawl-ref/source"
    else
      Dir.chdir "source"
    end
    system "make", "prefix=#{prefix}", "SAVEDIR=~/.crawl/saves/", "DATADIR=data/", "install"
  end
end

