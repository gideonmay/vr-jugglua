#!/usr/bin/env lua
MathTypes = {
	Vec = {
		{2, "b"};
		{2, "d"};
		{2, "f"};
		{2, "s"};
		{3, "b"};
		{3, "d"};
		{3, "f"};
		{3, "s"};
		{4, "b"};
		{4, "d"};
		{4, "f"};
		{4, "s"};
		{4, "ub"};
	};
	Matrix = {
		"d";
		"f";
	};
	Quat = {
		"Quat";
	}
}

makeTypename = {
	Vec = function(t)
		return ("Vec%d%s"):format(t[1], t[2])
	end;
	
	Matrix = function(t)
		return ("Matrix%s"):format(t)
	end;
	
	Quat = function()
		return "Quat"
	end
}

makeTypenameQualifier = function(f)
	return function(v)
		return "::osg::" .. f(v)
	end
end

description = {
	Vec = "vector";
	Matrix = "matrix";
	Quat = "quat";
}

map = function(s, f)
	local ret = {}
	for _, v in ipairs(s) do
		table.insert(ret, f(v))
	end
	return ret
end

print("#include <boost/mpl/set.hpp>")

for shortname, desc in pairs(description) do
	for _, specific in ipairs(MathTypes[shortname]) do
		print( ("#include <osg/%s>"):format(makeTypename[shortname](specific)) )
	end
end

print("namespace osgTraits {")
for shortname, desc in pairs(description) do
	local typelist = table.concat(map(MathTypes[shortname], makeTypenameQualifier(makeTypename[shortname])), ", ")
	print( ("	typedef boost::mpl::set<%s> %s_types;"):format(typelist, desc) )
	print( ("	template<typename T> struct is_%s : boost::mpl::has_key<%s_types, T>::type {};"):format(desc, desc))
end
print("} // end of namespace osgTraits")
