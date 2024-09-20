#pragma once

#include "../System/nvector.h"
#include "vertexelementdescriptor.h"

namespace Render
{
	/// ����� �������� ������� �������
	class VertexFormatDescriptor
	{
	public:
		/// �����������
		VertexFormatDescriptor();

		bool operator == (const VertexFormatDescriptor& other) const 
		{
			unsigned int vertexElementsCount = GetVertexElementsCount();
			if ( vertexElementsCount != other.GetVertexElementsCount() ) return false;
			else
			{
				for (unsigned int i = 0; i < vertexElementsCount; i++)
				{
					if (GetVertexElement(i) != other.GetVertexElement(i)) return false;
				}
			}
			return true;
		}
		bool operator != (const VertexFormatDescriptor& other) const { return !operator == (other); }


		/// ���������� �������� �������� �������
		void AddVertexElement(const VertexElementDescriptor& descr);
		void AssignVertexElements(const VertexElementDescriptor& descr, int count );
		/// ��������� �������� �������� �������
		const VertexElementDescriptor& GetVertexElement(unsigned int index) const;
		/// ��������� ���������� ��������� �������
		unsigned int GetVertexElementsCount() const;
		///
		int FindMaxUsageIndex(EVertexElementUsage usage) const;
	private:
		/// �������� ��������� ������
		nstl::vector<VertexElementDescriptor> vertexElementDescriptors;
	};
}; // namespace Render

template<> struct hash<Render::VertexFormatDescriptor> 
{
	size_t operator() (const Render::VertexFormatDescriptor& descr) const 
	{ 
		size_t res = 0;

		unsigned int vertexElementsCount = descr.GetVertexElementsCount();

		res += vertexElementsCount;

		for (unsigned int i = 0; i < vertexElementsCount; ++i)
		{
			res += descr.GetVertexElement(i).stream;
			res += descr.GetVertexElement(i).offset;
			res += descr.GetVertexElement(i).usageIndex;
		}

		return res; 
	}
};
