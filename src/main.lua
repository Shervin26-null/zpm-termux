local ZPM={}

ZPM.name="zpm"
ZPM.full="Zenith Package Matrix"
ZPM.version="0.0.2-alpha"


local UI={}

UI.reset="\27[0m"
UI.blue="\27[34m"
UI.green="\27[32m"
UI.red="\27[31m"


local function paint(c,t)
    return c..t..UI.reset
end


local function info(msg)
    print(paint(UI.blue,":: ")..msg)
end


local function ok(msg)
    print(paint(UI.green,"==> ")..msg)
end


local function fail(msg)
    io.stderr:write(
        "\n"
        ..
        paint(UI.red,"error: ")
        ..msg..
        "\n"
    )
end


local function run(cmd)
    return os.execute(cmd)
end



local ARGS={}
local FLAGS={
    yes=false,
    verbose=false,
    json=false
}

local COMMAND=nil

for i=1,#arg do

    local v=arg[i]

    if i==1 then

        COMMAND=v

    elseif v=="-y"
    or v=="--yes"
    then

        FLAGS.yes=true

    elseif v=="-v"
    or v=="--verbose"
    then

        FLAGS.verbose=true

    elseif v=="--json" then

        FLAGS.json=true

    else

        table.insert(
            ARGS,
            v
        )

    end

end


local function argget(n)

    return ARGS[n]

end





local HOME=
    os.getenv(
        "HOME"
    )
    or "."


local ZPMDIR=
    HOME
    ..
    "/.zpm"


local CACHE=
    ZPMDIR
    ..
    "/cache"


local HISTORY=
    ZPMDIR
    ..
    "/history"


os.execute(
    "mkdir -p "..CACHE
)

os.execute(
    "mkdir -p "..HISTORY
)



local function log_action(text)

    local f=
        io.open(
            HISTORY.."/log",
            "a"
        )

    if f then

        f:write(
            os.date(
                "%Y-%m-%d %H:%M:%S "
            )
            ..
            text
            ..
            "\\n"
        )

        f:close()

    end

end






local function startup()

    local home=
        os.getenv("HOME")

    if not home then

        fail(
            "HOME not set"
        )

        os.exit(1)

    end


    local dirs={
        home.."/.zpm",
        home.."/.zpm/cache",
        home.."/.zpm/history"
    }


    for _,d in ipairs(dirs) do

        os.execute(
            "mkdir -p "..d
        )

    end

end



startup()



local COMMANDS={}


local function register(name,fn)
    COMMANDS[name]=fn
end








local function exists(path)

    local f=
        io.open(
            path,
            "r"
        )

    if f then

        f:close()
        return true

    end

    return false

end



local function zpm_check()

    local required={
        ".zpm",
        ".zpm/cache",
        ".zpm/history"
    }


    for _,v in ipairs(required) do

        if not exists(
            os.getenv("HOME")
            ..
            "/"
            ..
            v
        )
        then

            os.execute(
                "mkdir -p "
                ..
                os.getenv("HOME")
                ..
                "/"
                ..
                v
            )

        end

    end


    return true

end






local LOCK=
    os.getenv("HOME")
    ..
    "/.zpm/lock"











local APT={}


function APT.run(command,args)


    local cmd=
        "apt "
        ..
        command


    if FLAGS.yes then

        cmd=
            cmd
            ..
            " -y"

    end


    if args then

        for _,v in ipairs(args) do

            cmd=
                cmd
                ..
                " "
                ..
                "'"..
                tostring(v):gsub(
                    "'",
                    "'\\''"
                )
                ..
                "'"

        end

    end


    if FLAGS.verbose then

        info(cmd)

    end


    local a,b,c=
        os.execute(cmd)


    if a==true
    or a==0
    or b=="exit"
    and c==0
    then

        return true

    end


    fail(
        command.." failed"
    )

    return false

end



function APT.update()

    info(
        "Synchronizing package lists"
    )


    if APT.run(
        "update"
    )
    then

        ok(
            "Package lists synchronized"
        )

    end

end



register("help",function()

print(
[[
zpm 0.0.2-alpha

Usage:
  zpm command [options]

Options:
  -y, --yes
  -v, --verbose
  --json

Commands:
]]
)

local names={}

for k in pairs(COMMANDS) do
    table.insert(names,k)
end

table.sort(names)

for _,k in ipairs(names) do
    print(
        "  "..k
    )
end

end)






register("sync",function()

    APT.update()

end)





register("add",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Installing "..pkg
    )

    log_action(
        "install "..pkg
    )


    if APT.run(
        "install",
        pkgs
    )
    then

        ok(
            "Installation complete"
        )

    end

end)



register("remove",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Removing "..pkg
    )

    log_action(
        "remove "..pkg
    )


    if APT.run(
        "remove",
        {
            pkg
        }
    )
    then

        ok(
            "Removal complete"
        )

    end

end)



register("reinstall",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Reinstalling "..pkg
    )


    if APT.run(
        "install",
        {
            "--reinstall",
            pkg
        }
    )
    then

        ok(
            "Reinstallation complete"
        )

    end

end)






register("upgrade",function()

    local target=argget(1)


    if not target
    or target=="all"
    then

        info(
            "Upgrading system"
        )


        if APT.run(
            "upgrade"
        )
        then

            ok(
                "System upgrade complete"
            )

        end


        return

    end


    info(
        "Upgrading "..target
    )


    if APT.run(
        "install",
        {
            target
        }
    )
    then

        ok(
            "Upgrade complete"
        )

    end

end)






register("search",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Searching for "..pkg
    )


    APT.run(
        "search",
        {
            pkg
        }
    )

end)



register("info",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Package information: "..pkg
    )


    APT.run(
        "show",
        {
            pkg
        }
    )

end)



register("download",function()

    local pkgs={}

    for i=1,#ARGS do
        table.insert(pkgs, ARGS[i])
    end

    local pkg=table.concat(pkgs," ")

    if #pkgs == 0 then

        fail(
            "missing package"
        )

        return

    end


    info(
        "Downloading "..pkg
    )


    if APT.run(
        "download",
        {
            pkg
        }
    )
    then

        ok(
            "Download complete"
        )

    end

end)



register("check-owned",function()

    local path=argget(1)

    if not path then

        fail(
            "missing path"
        )

        return

    end


    info(
        "Checking ownership"
    )


    local cmd=
        "dpkg -S "
        ..
        "'"
        ..
        path:gsub(
            "'",
            "'\\''"
        )
        ..
        "'"


    os.execute(
        cmd
    )

end)



register("doctor",function()

    info(
        "Running diagnostics"
    )


    local checks={
        "apt",
        "dpkg",
        "curl"
    }


    for _,v in ipairs(checks) do

        local r=
            os.execute(
                "command -v "..v
            )


        if r==true
        or r==0
        then

            ok(
                v.." available"
            )

        else

            fail(
                v.." missing"
            )

        end

    end


end)






register("history",function()

    local f=
        io.open(
            HISTORY.."/log",
            "r"
        )


    if not f then

        info(
            "No history"
        )

        return

    end


    print(
        f:read(
            "*a"
        )
    )

    f:close()

end)



register("clean",function()

    info(
        "Cleaning cache"
    )


    os.execute(
        "rm -rf "..CACHE.."/*"
    )


    ok(
        "Cache cleaned"
    )

end)






register("repair",function()

    info(
        "Repairing zpm environment"
    )


    zpm_check()


    ok(
        "Repair complete"
    )

end)



register("doctor",function()

    info(
        "Checking system"
    )


    local checks={
        "apt",
        "dpkg",
        "make",
        "luajit"
    }


    for _,v in ipairs(checks) do

        local r=
            os.execute(
                "command -v "..v.." >/dev/null"
            )


        if r==true
        or r==0
        then

            ok(
                v.." found"
            )

        else

            fail(
                v.." missing"
            )

        end

    end


end)



register("version",function()

    print(
        ZPM.name
        ..
        " "
        ..
        ZPM.version
    )

end)


local cmd=COMMAND


if not cmd then

    COMMANDS.help()

elseif COMMANDS[cmd] then

    COMMANDS[cmd]()

else

    fail(
        "unknown command: "
        ..
        cmd
    )

end
