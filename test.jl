# for i = 1:10
#     println("Hello World!")
#     s = 1
# end

s = 0

function test()
    s += 1
end

test()

println("Hello World $s")